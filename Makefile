TOPO = topo
TOPOEVAL = topoeval
MERGE_THRESHOLD = 50
EVAL_THRESHOLD = 150

DATASETS := $(basename $(notdir $(wildcard datasets/*.json)))

RESULTS_DIR := results

EVALS := $(patsubst %, eval-%, $(DATASETS))

.SECONDARY:

$(RESULTS_DIR)/%-topo.json: datasets/%.json
	@mkdir -p $(RESULTS_DIR)
	cat $< | $(TOPO) -d $(MERGE_THRESHOLD) --write-stats > $@

$(RESULTS_DIR)/%-topo-no-turns.json: datasets/%.json
	@mkdir -p $(RESULTS_DIR)
	cat $< | $(TOPO) --no-infer-restrs -d $(MERGE_THRESHOLD) --write-stats > $@

$(RESULTS_DIR)/%.random-nd.eval: datasets/%.json $(RESULTS_DIR)/%-topo.json
	@mkdir -p $(RESULTS_DIR)
	$(TOPOEVAL) -d $(EVAL_THRESHOLD) $^ > $@

$(RESULTS_DIR)/%.random-station.eval: datasets/%.json $(RESULTS_DIR)/%-topo.json
	@mkdir -p $(RESULTS_DIR)
	$(TOPOEVAL) --sample-stations -d $(EVAL_THRESHOLD) $^ > $@

$(RESULTS_DIR)/%.random-nd-no-turns.eval: datasets/%.json $(RESULTS_DIR)/%-topo-no-turns.json
	@mkdir -p $(RESULTS_DIR)
	$(TOPOEVAL) -d $(EVAL_THRESHOLD) $^ > $@

$(RESULTS_DIR)/%.random-station-no-turns.eval: datasets/%.json $(RESULTS_DIR)/%-topo-no-turns.json
	@mkdir -p $(RESULTS_DIR)
	$(TOPOEVAL) --sample-stations -d $(EVAL_THRESHOLD) $^ > $@

eval-%: $(RESULTS_DIR)/%-topo.json $(RESULTS_DIR)/%.random-nd.eval $(RESULTS_DIR)/%.random-station.eval  $(RESULTS_DIR)/%.random-nd-no-turns.eval $(RESULTS_DIR)/%.random-station-no-turns.eval
	@echo ===== Results for $* =======
	@echo Perf eval:
	@head -n13 $(RESULTS_DIR)/$*-topo.json | tail -n9
	@echo Random sampled WITH turn restrs:
	@cat $(RESULTS_DIR)/$*.random-nd.eval
	@echo Random sampled WITHOUT turn restrs:
	@cat $(RESULTS_DIR)/$*.random-nd-no-turns.eval
	@echo Station sampled WITH turn restrs:
	@cat $(RESULTS_DIR)/$*.random-station.eval
	@echo Station sampled WITHOUT turn restrs:
	@cat $(RESULTS_DIR)/$*.random-station-no-turns.eval

eval: | $(EVALS)

help:
	@cat README.md

check:
	@echo "topo version:" `$(TOPO) --version`
	@echo "results dir:" $(RESULTS_DIR)
	@echo "datasets:" $(DATASETS)

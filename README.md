# topo eval

Evaluation runs for topo.

## Usage

The following targets are provided:

**`list`**: List all available networks in `./datasets`

**`help`**: Show this README.

**`check`**: Run some checks on the environment.

**`eval`**: Run the evaluation, print results to stdout

## Run with Docker

Build the container:

    $ docker build -t topo-eval .

Run the evaluation:

    $ docker run topo-eval <TARGET>

where `<TARGET>` is the Makefile target (see above).

Intermediate files used in the evaluation will be output to `/output` inside the container. To retrieve them, mount `/output` to a local folder:

    $ docker run -v /local/folder/:/output topo-eval <TARGET>

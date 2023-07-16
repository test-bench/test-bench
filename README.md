# Template: Ruby Package

A template project for generating ruby packages.

## Usage

1. Go to https://github.com/test-bench/template-ruby-package/generate
2. Enter the new repository name and click create
3. Add the repository to [Contributor Assets](https://github.com/test-bench/contributor-assets)
4. Run `./get-projects.sh` from `contributor-assets`
5. Enter the repository directory and run:

   ```sh
   ./rename test_bench-some-project TestBench::Some::Project
   git add .
   git commit
   ```

#!/bin/bash
source_path=$(dirname "${0}")
cd "${source_path}"
cd ../resume
resume export index.html --theme elegant
# html-pdf ./index.html burlison_resume.pdf

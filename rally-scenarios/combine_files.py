#!/usr/bin/python

import argparse
import glob
import os, sys

parser = argparse.ArgumentParser()
parser.add_argument('--path', help='path to .yaml files, if specified then scenarios will be combined '
                                   'only for the specific component (e.g. nova)')
parser.add_argument('--filename', help='name of a new file where all scenarios will be stored')

args = parser.parse_args()
path = args.path
file_name = args.filename

if path is not None:
    for root, dirs, files in os.walk(path):
        if dirs:
            yaml_files = [file for file in glob.glob(str(path) + '/**/*.yaml')]
            break
        else:
            yaml_files = [file for file in glob.glob(str(path) + '/*.yaml')]
else:
    path = os.path.dirname(sys.argv[0])
    yaml_files = [file for file in glob.glob(str(path) + '/**/*.yaml')]

concat = '\n'.join([open(f).read() for f in yaml_files])

yaml_scenarios_file = open(file_name, 'w')
yaml_scenarios_file.write('---\n')
for line in concat.splitlines():
    if '---' not in line:
        yaml_scenarios_file.write(line + '\n')

yaml_scenarios_file.close()

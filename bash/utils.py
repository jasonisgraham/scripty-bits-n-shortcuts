#!/usr/bin/python

import os
from os import listdir
from glob import glob
import re

def find_files(**kwargs):
  path = kwargs.get('path') or '.'
  pattern = kwargs.get('pattern') or r''

  file_paths = [] # list to store all of the full file-paths

  for root, _, files in os.walk(path):
    for filename in files:
      file_path = os.path.join(root, filename)
      if re.compile(pattern).search(file_path):
        file_paths.append(file_path) # add it to the list

  return file_paths

def find_files_greater_than(max_size, **kwargs):
  path = kwargs.get('path') or '.'
  pattern = kwargs.get('pattern') or r''

  # exec get_file_paths() function and store its results in a variable
  full_file_paths = find_files(path=path, pattern=pattern)

  return filter(lambda file_path : (((os.path.getsize(file_path)) / 1024) / 1024) > max_size,
                full_file_paths)

def get_path_to_dir():
  return None

def convert_all_files_to_pdf(path='.'):
  result = []

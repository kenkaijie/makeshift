# SPDX-FileCopyrightText: 2024 Makeshift Team <tim.rose@acm.org>
# SPDX-License-Identifier: MIT
"""
Configuration file for the Sphinx documentation builder.
"""

import os

project = "makeshift"
copyright = "Copyright (c) 2024 Makeshift Team"
version = os.environ.get("VERSION", "unknown")

extensions = [
    "sphinx.ext.todo",
    "sphinx.ext.autosectionlabel",
    "myst_parser"
]

html_theme = "sphinx_rtd_theme"

html_theme_options = {
    'display_version': True,
    'navigation_depth': 3,
}

autosectionlabel_prefix_document = True

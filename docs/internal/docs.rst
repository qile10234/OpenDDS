########################
Documentation Guidelines
########################

This `Sphinx <https://www.sphinx-doc.org/en/master/>`_-based documentation is hosted on `Read the Docs <https://readthedocs.org>`_ and can be located `here <https://opendds.readthedocs.io/en/latest/>`__.
It can also be built locally.
To do this follow the steps in the following section.

********
Building
********

Run :ghfile:`docs/build.py`, passing the kinds of documentation desired.
Multiple kinds can be passed, and they are documented in the following sections.

Requirements
============

The script requires Python 3.6 or later and an internet connection if the script needs to download dependencies or check the validity of external links.

You might receive a message like this when running for the first time::

    build.py: Creating venv...
    The virtual environment was not created successfully because ensurepip is not
    available.  On Debian/Ubuntu systems, you need to install the python3-venv
    package using the following command.

        apt install python3.9-venv

If you do, then follow the directions it gives, remove the ``docs/.venv`` directory, and try again.

HTML
====

HTML documentation can be built and viewed using ``./docs/build.py -o html``.
If it was built successfully, then the front page will be at ``./docs/_build/html/index.html``.

A single page variant is also available using ``./docs/build.py -o singlehtml``
If it was built successfully, then the page will be at ``./docs/_build/singlehtml/index.html``.

PDF
===

.. note:: This has additional dependencies on LaTeX that are documented `here <https://www.sphinx-doc.org/en/master/usage/builders/index.html#sphinx.builders.latex.LaTeXBuilder>`__.

PDF documentation can be built and viewed using ``./docs/build.py -o pdf``.
If it was built successfully, then the PDF file will be at ``./docs/_build/latex/opendds.pdf``.

Dash
====

Documentation can be built for `Dash <https://kapeli.com/dash>`_, `Zeal <https://zealdocs.org/>`_, and other Dash-compatible applications using `doc2dash <https://github.com/hynek/doc2dash>`_.
The command for this is ``./docs/build.py dash``.
This will create a ``docs/_build/OpenDDS.docset`` directory that must be manually moved to where other docsets are stored.

Strict Checks
=============

``docs/build.py strict`` will promote Sphinx warnings to errors and check to see if links resolve to a valid web page.

.. note::

  The documentation includes dynamic links to files in the GitHub repo created by :ref:`docs-ghfile`.
  These links will be invalid until the git commit they were built under is pushed to a Github fork of OpenDDS.
  This also means running will cause those links to marked as broken.
  A workaround for this is to pass ``-c master`` or another commit, branch, or tag that is desired.

Building Manually
=================

It is recommended to use ``build.py`` to build the documentation as it will handle dependencies automatically.
If necessary though, Sphinx can be ran directly.

To build the documentation the dependencies need to be installed first.
Run this from the ``docs`` directory to do this::

  pip3 install -r requirements.txt

Then ``sphinx-build`` can be ran.
For example to build the HTML documentation::

  sphinx-build -M html . _build

****************
RST/Sphinx Usage
****************

* See `Sphinx reStructuredText Primer <https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html>`__ for basic RST usage.
* Inline code such as class names like ``DataReader`` and other symbolic text such as commands like ``ls`` should use double backticks: ````TEXT````.
  This distinguishes it as code, makes it easier to distinguish characters, and reduces the chance of needing to escape characters if they happen to be special for RST.
* `One sentence per line should be perfered. <https://rhodesmill.org/brandon/2012/one-sentence-per-line/>`__
  This makes it easier to see what changed in a ``git diff`` or GitHub PR and easier to move sentences around in editors like Vim.
  It also avoids inconsistencies involving what the maximum line length is.
  This might make it more annoying to read the documentation raw, but that's not the intended way to do so anyway.

Special Links
=============

There are a few shortcuts for linking to GitHub and OMG that are custom to OpenDDS.
These come in the form of `RST roles <https://docutils.sourceforge.io/docs/ref/rst/roles.html>`__ and are implemented in :ghfile:`docs/sphinx_extensions/links.py`.

.. _docs-ghfile:

ghfile
------

.. code-block:: rst

  :ghfile:`README.md`

  :ghfile:`the \`\`README.md\`\` File <README.md>`

  :ghfile:`the support section of the \`\`README.md\`\` File <README.md#support>`

  :ghfile:`check out the available support <README.md#support>`

  :ghfile:`java/docs/overview.html`

Turns into:

:ghfile:`README.md#support`

:ghfile:`README.md`

:ghfile:`the \`\`README.md\`\` File <README.md>`

:ghfile:`the support section of the \`\`README.md\`\` File <README.md#support>`

:ghfile:`check out the available support <README.md#support>`

:ghfile:`java/docs/overview.html`

The path passed must exist, be relative to the root of the repository, and will have to be committed, if it's not already.
If there is a URL fragment in the path, like ``README.md#support``, then it will appear in the link URL.

It will try to point to the most specific version of the file:

* If ``-c`` or ``--gh-links-commit`` was passed to ``build.py``, then it will use the commit, branch, or tag that was passed along with it.
* Else if the OpenDDS is a release it will calculate the release tag and use that.
* Else if the OpenDDS is in a git repository it will use the commit hash.
* Else it will use ``master``.

If the file ends in ``.html``, there will be an additional link to the file that uses https://htmlpreview.github.io/ so the file can be viewed directly in a web browser.

ghissue
-------

.. code-block:: rst

  :ghissue:`213`

  :ghissue:`this is the issue <213>`

  :ghissue:`this is **the issue** <213>`

Turns into:

:ghissue:`213`

:ghissue:`this is the issue <213>`

:ghissue:`this is **the issue** <213>`

ghpr
----

.. code-block:: rst

  :ghpr:`1`

  :ghpr:`this is the PR <1>`

  :ghpr:`this is **the PR** <1>`

Turns into:

:ghpr:`1`

:ghpr:`this is the PR <1>`

:ghpr:`this is **the PR** <1>`

omgissue
--------

.. code-block:: rst

  :omgissue:`DDSXTY14-29`

  :omgissue:`this is the issue <DDSXTY14-29>`

  :omgissue:`this is **the issue** <DDSXTY14-29>`

Turns into:

:omgissue:`DDSXTY14-29`

:omgissue:`this is the issue <DDSXTY14-29>`

:omgissue:`this is **the issue** <DDSXTY14-29>`

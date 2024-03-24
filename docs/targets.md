# Makeshift Targets

Makeshift provides default implementations for the [standard targets of GNU make](https://www.gnu.org/software/make/manual/html_node/Standard-Targets.html)
as well as custom targets. Rules for these targets are supported supported for each language type.

Default implementations for targets perform no action and are populated based on the added `language=` or other support
declared in the `Makefile`.

- `all` is an alias for build.
- `build` builds all the things.
- `test` runs tests.
- `install`, `uninstall` installs or removes artefacts to a standard location.
- `clean`, `distclean` performs various cleanup tasks. `distclean` also removed distribution artefacts.
- `package` performs packaging actions.
- `doc` builds documentation.

## Help and Debugging targets

Other targets are also provided, these are prepended with the `+` character.

- `+help` --prints some help text based on the makefiles you have included
- `+vars` --prints all of the defined variables, and their values (disabled on Windows)
- `+var[name]` --prints a single variable value
- `+stddirs` --prints the list of "standard" build and install directories
- `+version` --prints the current makeshift version
- `+features` --prints the current make features
- `+dirs` --prints the include directories used by make
- `+files` --prints the additional files included by make

## Target Information

### all

The `all` target is the default target and only performs build.

### build

The `build` target is the main target for processing the source into it's finished form. For compiled languages this may
invoke the compiler. For interpreted languages or translation steps, this may invoke different commands.

```{seealso}

Each language specified will detail the `build-<LANG>` target and its usage. Refer to individual languages for more
information.

```

Languages add steps to the `build` target by first specifying a language specific build target `build-<LANG>`, then
adding the target as a dependent for the overall `build` target. For the `c` language, it would look like the following
snippet.

```make
build:	build-c
build-c:	$(C_MAIN)
	...
    ...
```

The `build` target is provided by makeshift's core, and should not be overridden. By default, `build` has no dependents,
and performs no actions.

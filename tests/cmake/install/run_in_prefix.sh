set -e

export OPENDDS_INSTALL_PREFIX="$1"
export ACE_ROOT="$OPENDDS_INSTALL_PREFIX"
export TAO_ROOT="$OPENDDS_INSTALL_PREFIX"
export DDS_ROOT="$OPENDDS_INSTALL_PREFIX"
export PATH="$OPENDDS_INSTALL_PREFIX/bin:$PATH"

shift

exec "$@"

# This script gets a container ready to run our various tests in BuildKite

# source /etc/os-release
# echo $PRETTY_NAME

# Install Chef - We need the tools that come with Chef. 
echo "--- Installing Chef"
curl -fsSL https://omnitruck.chef.io/chef/install.sh | bash -s -- -c "stable" -P "chef" -v 18
export PATH="/opt/chef/bin:${PATH}"

echo "--- Container Config..."
echo "ruby version:"
ruby -v
echo "bundler version:"
bundle -v

echo "--- Preparing Container..."

export FORCE_FFI_YAJL="ext"
export CHEF_LICENSE="accept-no-persist"
export BUNDLE_GEMFILE="/workdir/Gemfile"

# make sure we have the network tools in place for various network specs
if [ -f /etc/debian_version ]; then
  touch /etc/network/interfaces
fi

# remove default bundler config if there is one
rm -f .bundle/config

echo "+++ Run tests"

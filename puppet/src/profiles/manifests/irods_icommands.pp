# run iCommands defined in irods::icommands hiera hash
class profiles::irods_icommands {
  include ::irods::globals
  contain ::irods::icommands
}

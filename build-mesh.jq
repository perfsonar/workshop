#
# Generate the workshop mesh from a skeleton.
#
# Expectations:
#
#  - Clean CSV host list to be imported with --rawfile as $hosts_clean
#  - Mesh skeleton to be imported with --slurpfile as $mesh
#


# Convert list of CSV to objects
def processed_input:
  [
      split("\n")[]
    | select(. != "")
    | split(",")
    | { "key": .[0], "value": { "private": .[1], "public": .[2]} }
  ]
  | from_entries
;


# Pick out the archive
def archive:
  if (.["archive"] == null)
  then error("No archive in input")
  else .["archive"]
  end
;


# Pick out the testpoints
def testpoints:
    [
        to_entries[]
      | select(.key != "archive")
    ]
  | from_entries
;


# Generate the address list from the testpoints
def addresses:
    [
      to_entries[]
      | {
          "key": .key,
	  "value": {
	    "address": .value.private
	  }
	}
    ]
  | from_entries
;


# Generate a list of testpoint addresses
def group_addresses:
  [ keys[] | { "address": . } ]
;


# Generate the URL for the archive
def archive_url:
  "https://\(.private)/logstash"
;



#
# Main Program
#

  $hosts_clean | processed_input as $data
| ($data | archive) as $archive
| ($data | testpoints) as $testpoints
| . = $mesh[0]
| .addresses = ($testpoints | addresses)
| .groups.testpoints.addresses = ($testpoints | group_addresses)
| .archives.workshop.data._url = ($archive | archive_url)

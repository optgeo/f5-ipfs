require 'lmdb'

db = LMDB.new('lmdb').database
csv = File.open('f5.csv', 'w')
md = File.open('f5.md', 'w')
db.each {|path, cid|
  csv.print "#{path},#{cid}\n"
  md.print <<-EOS
- [#{path}](https://smb.optgeo.org/ipfs/#{cid})
  EOS
}
csv.close
md.close

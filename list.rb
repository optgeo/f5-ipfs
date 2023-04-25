require 'lmdb'

def log(path, cid)
  $db[path] = cid
  $stderr.print "#{path} -> #{cid}\n"
end

def get(year, fn)
  path = "#{year}/#{fn}"
  $stderr.print "[#{Time.now}] adding #{path}.\n"
  s = `curl --silent -u $TERRAS_USER_PASSWORD ftp://terras.gsi.go.jp/data/coordinates_F5/GPS/#{path}`
  IO.popen('ipfs add --progress', 'w+') {|pipe|
    pipe.puts s
    pipe.close_write
    l = pipe.read
    cid = l.strip.split(' ')[-1]
    log(path, cid)
  }
end

$db = LMDB.new('lmdb', :mapsize => 100 * 1024 * 1024).database
1996.upto(2023) {|year|
  s = `curl --silent -u $TERRAS_USER_PASSWORD ftp://terras.gsi.go.jp/data/coordinates_F5/GPS/#{year}/`
  s.split("\n").each {|l|
    r = l.split
    fn = r[-1]
    get(year, fn)
  }
}

def get(year, fn)
  s = `curl --silent -u $TERRAS_USER_PASSWORD ftp://terras.gsi.go.jp/data/coordinates_F5/GPS/#{year}/#{fn}`
  p s
end

1996.upto(2023) {|year|
  s = `curl --silent -u $TERRAS_USER_PASSWORD ftp://terras.gsi.go.jp/data/coordinates_F5/GPS/#{year}/`
  s.split("\n").each {|l|
    r = l.split
    fn = r[-1]
    get(year, fn)
  }
}

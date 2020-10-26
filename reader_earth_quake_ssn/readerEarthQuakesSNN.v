module reader_earth_quake_ssn

import sqlite
import time

pub struct ReaderEarthQuakesSNN {
  pub mut: db_path string
  mut: db sqlite.DB
}

pub fn (mut g ReaderEarthQuakesSNN) parse_data(data string) string {
  mut temp := data
  mut item := ""

  // init database
  g.init_db()

  mut idx := temp.index("</title>") or { -1 }
  temp = temp.substr(idx+8, temp.len)
  
  for true {
    item = temp.find_between("<title>", "</title>")
    if item.len == 0 { break }

    g.save_data(item)

    idx = temp.index("</title>") or { -1 }
    if idx == -1 { break }
    temp = temp.substr(idx+8, temp.len)
  }

  return "ok"
}

fn (mut g ReaderEarthQuakesSNN) save_data(data string) {
  datas := data.split(',')

  //println("INSERT INTO earthquakes(intensity, location, state, created) VALUES (" + datas[0] + ", '" + datas[1].trim_space() + "', '" + datas[2].trim_space() + "', '" + time.now().str() + "')")
  g.db.exec("INSERT INTO earthquakes(intensity, location, state, created) VALUES (" + datas[0] + ", '" + datas[1].trim_space() + "', '" + datas[2].trim_space() + "', '" + time.now().str() + "')")
  
  println(datas[1])
}

fn (mut g ReaderEarthQuakesSNN) init_db() {
  g.db = sqlite.connect('$g.db_path\\earthquakes.db') or { println("error when creating sqlite database file, check permission to write dir: $err") return }
  g.db.exec("CREATE TABLE IF NOT EXISTS earthquakes (id INTEGER PRIMARY KEY, intensity DECIMAL(2,1) DEFAULT 0.0, location TEXT DEFAULT '', state TEXT DEFAULT '', created TEXT);")
}

// TODO add migration for versioning database
fn (mut g ReaderEarthQuakesSNN) upgrade() {

}
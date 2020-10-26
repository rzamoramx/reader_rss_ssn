module main

import net.http
import os
import reader_earth_quake_ssn

fn main() {
  resp := http.get('http://www.ssn.unam.mx/rss/ultimos-sismos.xml') or {
    println('failed to fetch data from the server $err')
    return
  }

  mut reader_eq := reader_earth_quake_ssn.ReaderEarthQuakesSNN{}
  reader_eq.db_path = os.real_path('.')

  println(reader_eq.parse_data(resp.text))
}


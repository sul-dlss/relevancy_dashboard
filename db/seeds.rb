# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Endpoint.find_or_create_by(url: 'http://sw-solr-g.stanford.edu:8983/sw-relevancy/select')
Endpoint.find_or_create_by(url: 'https://sul-solr-tester.stanford.edu/searchworks-dev/select')

Search.find_or_create_by(query_params: 'defType=edismax&q=%7B%21pf2%3D%24p2+pf3%3D%24pf3%7D%2220th+-+21st+centuries%22&qt=search&sort=score+desc%2C+pub_date_sort+desc%2C+title_sort+asc')

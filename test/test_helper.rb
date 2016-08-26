#----------------------------------------

Artist = Yequel::Model.new('test')

Artist.insert(:id=>1, :name=>"YJ")
Artist.insert(:id=>2, :name=>"AS")
Artist.insert(:id=>3, :name=>"AS")

Artist.insert(:id=>1, :name=>"NO INSERT")

Artist.update(:id=>1, :name=>"YJM")
Artist.update(:id=>9, :name=>"NO UPDATE")

Artist.insert(:id=>4, :name=>"TEST RECORD")
Artist.delete(4)

#-----------------------------------------------------------------------
Artist[1]

Artist.first
Artist.last
Artist.count
Artist.all

Artist.where(:id=>1)
Artist.where(:id => 1)
Artist.where(:name => 'AS')

Artist.where(:id => 3).where(:name => 'AS')

Artist.where('id > 0')      # atype = 1
Artist.where('id <= 2')
Artist.where('id >= 2')
Artist.where('id != 1')     # atype = 4

Artist.where('id = ?', 1)

Artist.order(:name)
Artist.where('id > 1').order(:name)
Artist.order(:name).all

#Artist.where('level < 3').order(:name)
#Artist.order(:name).where('level < 3')

Artist.where(:name => 'AS').order(:id)
Artist.order(:id).where(:name => 'AS')

artist=Artist[1]
artist[:name]='xxxxyyyzz'
artist.save

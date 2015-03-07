load 'regex'
user_path =: '~user/projects/fpcontest_201503/'
NB. string utils
strim =: (drop ^: (' '&=@:take) ^: _) f.
etrim =: (|. @: strim @: |.) f.
trim =: (strim @: etrim) f.
droplast =: |.@:(1&}.)@:|.
makestr =: (CRLF&,) @: droplast @: ; @: ((,&';') each)
NB. settings from files
splitq =: 0&{@:I.@:(' '&=) (".@:{. ; [: trim >:@:[ }. ]) ]
kategories =: (,&('-';0)) |."1 > splitq each 'b' fread jpath user_path, 'Frequencies.txt'
countries_coef =: > splitq each 'b' fread jpath user_path, 'States.txt'
ccoefs =: > (0 { |: countries_coef)
countries =: 1 { |: countries_coef
regions =: |."1 countries_coef
getq =: (0&{@:I.@:(':'&=)) take ]
NB. search country name and return quantity or -
alt =: ((''"_)@:]) ` (getq@:]) @. ((_1&<)@:{.@:{.@:rxmatch)
vv =: (<@:('-'"_)) ` ] @. (0: < (#@:>)) @: (>@:(0&<@:#&.>) # ])
fn =: dyad : 0"0 _
 vv (((> x)&alt each) y)
)
NB. find column by name
fcol =: dyad : 0 
  idxs =. >@:((_1&<)@:(0&{)@:(0&{) @: (y&rxmatch) each) (0 { x)
  if. 0 = (+./) idxs do. _1 else. (0&{)@:I. idxs end.
)
NB. find row by name
frow =: (|: @: [) fcol ]
NB. drop 'name' column from 'table'
dropt =: dyad : 0
  idx =. x fcol y
  if. _1 < idx do. (|: idx take |: x) ,. (|: (idx+1) drop |: x) else. x end.
)
NB. find quantity by name
fquan =: >@:(1&{)@:({&kategories)@:(kategories&frow)
NB. find region coefficient by name
fcoef =: >@:(1&{)@:({&regions)@:(regions&frow) 
NB. Main task
update =: dyad : 0
  lines =. 'b' fread jpath user_path , y
  name =. trim 0 {:: lines 
  (x dropt name) ,. take |: name ; (countries fn lines)
)
NB. export to file
exportcsv =: ((makestr"1) @: [) fwrite (user_path , ])
NB. statistics for each regions
rowstat =: +/@:;@:(fquan each)@:(1&drop)
regstat =: ((0&{) , (<@:":@:rowstat))"1 @: (1&drop) 
NB. statistics for each bug
colstat =: +/ @:(ccoefs&*@:;@:(fquan each)@:(1&drop))
bugstat =: (((0&{) , (<@:":@:colstat))"1 @: (1&drop)) @: |:
NB. main task
csv =: 'Регион' ; countries
rescsv =: 'Semipunctata.dat' update~ 'Populii.dat' update~ 'Melolontii.dat' update~ 'Horticola.dat' update~ 'Desetilinjata.dat' update~ 'Aurata.dat' update~ csv 
rescsv exportcsv 'result.csv'
(regstat rescsv) exportcsv 'result3.csv'
(bugstat rescsv) exportcsv 'result4.csv'
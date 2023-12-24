
--3Return the result of this XML data as table (XML shredding(From XML To Table)) : 

declare @docs xml=
        '<book genre="VB" publicationdate="2010"> 

               <title>Writing VB Code</title> 

                   <author> 

                         <firstname>ITI</firstname> 

                         <lastname>ITI</lastname> 

                  </author> 

                 <price>44.99</price> 

               </book>' 
declare @hdocs INT
Exec sp_xml_preparedocument @hdocs output, @docs
select * INTO NewTable9
FROM OPENXML (@hdocs,'//book')
with(genre varchar(10)'@genre',
publicationdate date '@publicationdate',
tiltle varchar(10)'title',
authorfirst varchar(10)'author/firstname',
authorsecond varchar(10)'author/lastname',
price float'price')

Exec sp_xml_removedocument @hdocs


select * from NewTable9


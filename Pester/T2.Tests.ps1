describe MyTest {
 $param = @{
         'var' = 123
     }

it 'verifies 123' {
      $param.var | should be 123
     
 }

it 'verifies type int' {
      $param.var | should beoftype int
 }

it 'verifies count' {
 @(1,2,3).Count | should be 3
 }

}




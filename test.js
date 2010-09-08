/*
* Comment Test 
* function() {
*/
{
  /* a [{( */
  // b [{(
  comment('/* com', a /* [{( */); /* c */ // d
    ok();
  // Assign Test
  var a, /* { */
      b, // [
      c = '{'
  var a = "Hello" +
          (3+4) +
          "World"
  d = function() {
    aoeu
  }
  var k = function() {
    var k=3,
        m=4
  }

  var rurl = /{[('"/,
      r20 = /%20/g,

  a = 1,
  b = 2
  a = 1 +
      2 *
      3
}

// Function nested
;(function($) {
    $(document).ready(function() {
        $('#foo').click(function() {
            $.post(url, {
                a: 1, 
                b: 2,
              }, function() {
                ok(); 
              }
            );
        });
    });
})(jQuery);

// Array Object Test
string_test("('",'("',"[",'{',"\"{","\\'{"); 
{
  array_object_test: [
    1,
    2,
    {
      a: [3,4],
      b: [
        3,
        4
      ],
      c: string_test("('",'("',"[",'{',"\"{","\\'{"),
      function_test: function() {
        return 0;
      },
      one_line_function_test: function() { return [1] }
    }
  ]
}

// One Line Test
{
  if( a == b &&
    c == d ||
    e == f) 
  {
    ok();
  }
  if(a) {
    b;
  } else {
    e;
  }
  if (a)
    b;
  if(a)
    b;
  else if(k) {
    aeou
  } else
    c;
  while(true)
    foo += 1;
  try
    a;
  catch
    b;
  finally
    c;
  ok();
}

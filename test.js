/*
* Comment Test 
*/
{
  /* a [{( */
  // b [{(
  comment('/* com', a /* [{( */); /* c */ // d
  ok();
  var a, /* { */
      b, // [
      c = '{'
  var a = 1,
      c = 0;
  a = 1 +
      2 *
      3
  c = 1+
      2+
      3
  d;
  if( a == b &&
    c == d ||
    e == f) 
  {
    ok();
  }
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

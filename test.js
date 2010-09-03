/*
* Comment Test 
*/
{
  /* comment a { */
  // comment c {
  comment('/* com' c, a /* commen{t a */); /* c */ // d
  ok();
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
  array_test: [
    1,
    2
  ],

  array_hash_test: [
    {
      a: 'a',
      b: [3,4],
      c: [
        3,
        4
      ],
      d: string_test("('",'("',"[",'{',"\"{","\\'{"); 
    }
  ],

  function_test: function() {
    return 0;
  },

  one_line_function_test: function() { return [1] };
}

jQuery(function($) {
        $('.fot-answers input.correct').change(function() {
            setTimeout(function() {
                $.get('/engine/modules/fast_online_tests.php', function(data) {
                    $('.fast-online-test').replaceWith(data);
                });
            }, 2000);
        });
});

var presentation;

var term = Webterm('http://192.168.1.4:9090/terminal', '#vim_terminal', {
    scale: false,
    rows: 40,
    columns: 120,
});
$(window).load(function() {
    // Create the HTML for the indicator
    $("#presentation > div").each(function(index,elm) {
        $(elm).append("<div class='counter'>" + (index) + "<br>Follow along at http://brittg.com/vim</div>");
    });

    presentation = new Presenteer(
        "#presentation",
        $("#presentation > div"),
        { onAfterEnter : function(elm) {  } }
    );

    var locked = false;
    var last = 1;

    $(document).keydown(function(e) {
        var current = presentation.getCurrentIndex();
        if (current == 0) {
            if (!(e.altKey && e.ctrlKey)) {
                return;
            }
        }
        switch (e.keyCode) {
        case 32:
        case 39:
        case 40:
            if (current == 0) {
                return;
            }
            if (!locked) {
                presentation.next();
            }
            break;
        case 38:
        case 37:
            if (current == 0) {
                return;
            }
            if (!locked) {
                presentation.prev();
            }
            break;
        case 84:
            if (!locked) {
                if (current == 0) {
                    presentation.show(last);
                } else {
                    last = current;
                    presentation.show(0)
                }
            }
            break;
        case 76:
            if (e.ctrlKey && e.altKey) {
                locked = !locked;
            }
            break;
        default:
            console.log(e);
            break;
        }
    });
    //$("#presentationcontainer").on("click", function() { presentation.next(); });
    $('.initial').focus();
    presentation.start();
    presentation.show(1);
});

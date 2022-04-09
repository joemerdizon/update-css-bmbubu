var currentMousePos = { x: -1, y: -1 };

$(function () {
    var lastPos = { x: -1, y: -1 };

    $(document).mousemove(function (event) {
        currentMousePos.x = event.pageX;
        currentMousePos.y = event.pageY;
    });

    setInterval(function () {
        if (currentMousePos.x != lastPos.x || currentMousePos.y != lastPos.y) {
            $.ajax({
                type: "POST",
                url: "../../ManageUPWebService.asmx/KeepAuthenticationAlive",
                contentType: "application/json; charset=utf-8",
                dataType: "json"
            });
        };

        lastPos.x = currentMousePos.x;
        lastPos.y = currentMousePos.y;
    }, 4 * 60 * 1000) //every 4 minutes
});
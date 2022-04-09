$(document).ready(function () {
    $('#PlaybookCat1').change(function (e) {
        $this = $(e.target);
        $.ajax({
            beforeSend: function () {
                $("#LoadingModal").modal('show');
            },
            async: true,
            type: "POST",
            url: "../ManageUPWebService.asmx/GetPlaybookSecondCat",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: JSON.stringify({ FirstCat: $this.val()}),
            success: function (data) {
                var mySelect = $("#PlaybookCat2");
                mySelect.empty();
                mySelect.append(
                        $('<option></option>').val('0').html('Select')
                    );
                $.each(data.d, function (val, text) {
                    mySelect.append(
                        $('<option></option>').val(text.Value).html(text.Text)
                    );
                });

                //if ($.url().param('cat1') !== undefined && $.url().param('cat2') !== undefined) {
                //    $("#PlaybookCat2").val($.url().param('cat2'));
                //    $("#PlaybookCat2").trigger('change');
                //};
            },
            complete: function () {
                $("#LoadingModal").modal('hide');
            },
        });
    });

    $('#PlaybookCat2').change(function (e) {
        $this = $(e.target);
        $.ajax({
            beforeSend: function () {
                $("#LoadingModal").modal('show');
            },
            type: "POST",
            async: true,
            url: "./processes.aspx/GetPlaybook",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: JSON.stringify({ cat2: $this.val(), cat1 : $("#PlaybookCat1").val() }),
            success: function (data) {
                $("#pb").html('');
                $("#pb").html(data.d);
                $("#playbooktable").DataTable();
            },
            complete: function () {
                $("#LoadingModal").modal('hide');
            },
        });
    });

    if ($.url().param('cat1') !== undefined && $.url().param('cat2') !== undefined) {
        $("#PreviousEdit").html('');
        var data = "";
        data = data.concat("<h3>My Edits</h3>");
        data = data.concat("<input type='button' class='btn btn-success' value='Previous Edit' onclick=EditPlaybook('" + $.url().param('pbid') + "') />");
        $("#PreviousEdit").html(data);
    };
})

function ShowDD(cat, pid, iscat) {
    var iscatBool;

    if (parseInt(iscat) == 0) {
        iscatBool = false;
    }
    else {
        iscatBool = true;
    }

    var DTO = { 'id': pid, 'cat': cat, 'iscat': iscatBool };

    $.ajax({
        beforeSend: function () {
            $("#LoadingModal").modal('show');
        },
        type: "POST",
        url: "./processes.aspx/GetItems",
        data: JSON.stringify(DTO),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            $("#DocList").html('');
            $("#DocList").html(data.d);
            //  $("#playbookmedia").DataTable();
            $("#LoadingModal").modal('hide');
            $("#DocumentsModal").modal('show');
        }
    });
}

function ShowMedia(catid, doclink) {
    switch (parseInt(catid)) {
        case 1:
            var win = window.open(doclink, '_blank');
            break;
        case 2:
            ShowVideo(doclink);
            break;
    }
    return true;
}

function PlaybookTables() {
    $("#playbooktable").DataTable();
}

function ShowVideo(url) {
    $('#VideoModalPlayer').modal({
        backdrop: true,
        keyboard: true,
        show: false
    }).css({
        // make width 90% of screen
        'width': function () {
            return ($(document).width() * .5) + 'px';
        },
        // center model
        'margin-left': function () {
            return -($(this).width() / 2);
        }
    });

    $("#videoplayer").attr('src', url);

    $("#VideoPlayerModal").on('hide', function () {
        $("#videoplayer").attr('height', 500);
        $("#videoplayer").attr('width', 650);
        $("#videoplayer").attr('src', '');
    });

    $("#VideoModalPlayer").modal('show');
}

function CloseYouTubePlayer() {
    $("#videoplayer").attr('src', '');
    $("#VideoModalPlayer").modal('hide');
}

function EditPlaybook(playbookid) {
    var url = "./addplaybook.aspx?pbid=" + playbookid;
    $(location).attr('href', url);
}

function GoToPlaybook() {
    var url = "./processes.aspx";
    $(location).attr('href', url);
}

$(document).ajaxStop(function () {
    //if ($.url().param('cat1') !== undefined && $.url().param('cat2') !== undefined) {
    //    $("#PlaybookCat1").val($.url().param('cat1'));
    //    $("#PlaybookCat2").val($.url().param('cat2'));
    //    $("#PlaybookCat2").trigger('change');
    //} else {
    //};

    $("#LoadingModal").modal('hide');
});

$(document).ajaxStart(function () {
    $("#LoadingModal").modal('show');
})
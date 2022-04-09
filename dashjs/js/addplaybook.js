$(document).ready(function () {
    for (var i = 0 ; i < 4 ; i++) {
        $("#PlaybookCat" + (i + 1) + "").change(function (e) {
            $this = $(e.target);
            if ($this.val() == '1') {
                currentControl = this;
                $("#NewCategoryModal").modal('show');
            }
        });
    }

    $.ajax({
        beforeSend: function () {
            $("#LoadingModal").modal('show');
        },
        type: "POST",
        url: "../ManageUPWebService.asmx/GetCategoryByID",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ CatId: '1' }),
        success: function (data) {
            var mySelect = $("#PlaybookCat1");
            mySelect.empty();
            mySelect.append(
                    $('<option></option>').val('0').html('Select')
                );
            mySelect.append(
        $('<option></option>').val('1').html('< New >')
    );
            $.each(data.d, function (val, text) {
                mySelect.append(
                    $('<option></option>').val(text.Value).html(text.Text)
                );
            });
        },
        complete: function () {
            $("#LoadingModal").modal('hide');
        },
    });

    $.ajax({
        beforeSend: function () {
            $("#LoadingModal").modal('show');
        },
        type: "POST",
        url: "../ManageUPWebService.asmx/GetCategoryByID",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ CatId: '2' }),
        success: function (data) {
            var mySelect = $("#PlaybookCat2");
            mySelect.empty();
            mySelect.append(
                    $('<option></option>').val('0').html('Select')
                );
            mySelect.append(
        $('<option></option>').val('1').html('< New >')
    );
            $.each(data.d, function (val, text) {
                mySelect.append(
                    $('<option></option>').val(text.Value).html(text.Text)
                );
            });
        },
        complete: function () {
            $("#LoadingModal").modal('hide');
        },
    });

    $.ajax({
        beforeSend: function () {
            $("#LoadingModal").modal('show');
        },
        type: "POST",
        url: "../ManageUPWebService.asmx/GetCategoryByID",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ CatId: '3' }),
        success: function (data) {
            var mySelect = $("#PlaybookCat3");
            mySelect.empty();
            mySelect.append(
                    $('<option></option>').val('0').html('Select')
                );
            mySelect.append(
                    $('<option></option>').val('1').html('< New >')
                );

            $.each(data.d, function (val, text) {
                mySelect.append(
                    $('<option></option>').val(text.Value).html(text.Text)
                );
            });
        },
        complete: function () {
            $("#LoadingModal").modal('hide');
        },
    });

    $.ajax({
        beforeSend: function () {
            $("#LoadingModal").modal('show');
        },
        type: "POST",
        url: "../ManageUPWebService.asmx/GetCategoryByID",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ CatId: '4' }),
        success: function (data) {
            var mySelect = $("#PlaybookCat4");
            mySelect.empty();
            mySelect.append(
                    $('<option></option>').val('0').html('Select')
                );
            mySelect.append(
                     $('<option></option>').val('1').html('< New >')
                );
            $.each(data.d, function (val, text) {
                if (text.Text != "") {
                    mySelect.append(
                        $('<option></option>').val(text.Value).html(text.Text)
                    );
                }
            });
        },
        complete: function () {
            $("#LoadingModal").modal('hide');
        },
    });
});

$(document).ajaxStop(function () {
    if ($.url().param('pbid') !== undefined) {
        LoadPlaybookItem($.url().param('pbid'));
        $("#pbid").val($.url().param('pbid'));
        $("#PageSubtitle").html('');
        $("#PageSubtitle").html('Edit Playbook Item');
    } else {
        $("#PageSubtitle").html('');
        $("#PageSubtitle").html('New Playbook Item');
        AddRefItem('OtherRefs', false,'');
        AddRefItem('MiscRefs', false,'');
    };

    $("#LoadingModal").modal('hide');
});

$(document).ajaxStart(function () {
    $("#LoadingModal").modal('show');
});

var currentControl;

function ResetCategory() {
    var mySelect = $("#" + currentControl.id + "");
    mySelect.val('0');
}

function InsertNewCat() {
    var mySelect = $("#" + currentControl.id + "");
    var data = $("#NewCatEntry").val();

    if (data === "") {
        showErrorMsgs($('#NewCategoryModal'), ['Category cannot be empty.']);
    }
    else {
        mySelect.append(
            $('<option></option>').val(data).html(data)
    );
        mySelect.val(data);
        $("#NewCategoryModal").modal('hide');
        $("#NewCatEntry").val('');
    }
}

function SavePlaybook() {
    var urlregex = new RegExp("^(http|https|ftp)\://([a-zA-Z0-9\.\-]+(\:[a-zA-Z0-9\.&amp;%\$\-]+)*@)*((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|([a-zA-Z0-9\-]+\.)*[a-zA-Z0-9\-]+\.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{2}))(\:[0-9]+)*(/($|[a-zA-Z0-9\.\,\?\'\\\+&amp;%\$#\=~_\-]+))*$");
    var link = "";
    var OtherCatRefs = "";
    var isValid = true;

    $("#OtherRefs").children("input[type=text]").each(function () {
        link = $(this).val();

        if (link != "") {
            if (urlregex.test(link) == false) {
                isValid = false;
            }
            else {
                OtherCatRefs = OtherCatRefs.concat(link);
                OtherCatRefs = OtherCatRefs.concat(",")
            }
        }
    });

    if (isValid == false) {
        $("#InvalidLinkModal").modal('show');
        return;
    }

    if ($("#PlaybookCat1").val() == "1" || $("#PlaybookCat1").val() == "0" || $("#PlaybookCat2").val() == "1" || $("#PlaybookCat2").val() == "0" || $("#PlaybookCat3").val() == "1" || $("#PlaybookCat3").val() == "0" || OtherCatRefs == "") {
        $("#ErrorModal").modal('show');
        return;
    }
    else {
        var FristCatName = $("#PlaybookCat1").val();
        var SecondCatName = $("#PlaybookCat2").val();
        var OtherCatName = $("#PlaybookCat3").val();
        var OtherCatDesc = $("#OtherCatDesc").val();
        var MiscCatName = $("#PlaybookCat4").val();
        var MiscCatRefs = "";

        if (MiscCatName === 0) {
            MiscCatName == "";
        }

        OtherCatRefs = OtherCatRefs.substring(0, OtherCatRefs.length - 1);

        $("#MiscRefs").children("input[type=text]").each(function () {
            link = $(this).val();

            if (link != "") {
            if (urlregex.test(link) == false) {
                $("#InvalidLinkModal").modal('show');
                return;
            }
            else {
                MiscCatRefs = MiscCatRefs.concat(link);
                MiscCatRefs = MiscCatRefs.concat(",")
                 }
            }
        });

        MiscCatRefs = MiscCatRefs.substring(0, MiscCatRefs.length - 1);

        var pbid = $("#pbid").val();
        var data;

        if (pbid == "") {
            data = { PlaybookID: 0, FristCatName: FristCatName, SecondCatName: SecondCatName, OtherCatName: OtherCatName, OtherCatDesc: OtherCatDesc, OtherCatRefs: OtherCatRefs, MiscCatName: MiscCatName, MiscCatRefs: MiscCatRefs };
        }
        else {
            data = { PlaybookID: pbid, FristCatName: FristCatName, SecondCatName: SecondCatName, OtherCatName: OtherCatName, OtherCatDesc: OtherCatDesc, OtherCatRefs: OtherCatRefs, MiscCatName: MiscCatName, MiscCatRefs: MiscCatRefs };
        }

        $.ajax({
            beforeSend: function () {
                $("#LoadingModal").modal('show');
            },
            global: false,
            type: "POST",
            url: "../ManageUPWebService.asmx/AddPlaybookItem",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: JSON.stringify(data),
            success: function (returnData) {
                if (returnData.d > 0) {
                    if (pbid == "") {
                        $("#SuccessModalMessage").html('');
                        $("#SuccessModalMessage").html('Playbook item create successfully');
                    }
                    else {
                        $("#SuccessModalMessage").html('');
                        $("#SuccessModalMessage").html('Playbook item edited successfully');
                    }
                    $("#pbredirect").click(function () {
                        var url = "./processes.aspx?cat1=" + FristCatName + "&cat2=" + SecondCatName + "&pbid=" + pbid;
                        $(location).attr('href', url);
                    });
                    $("#SuccessModal").modal('show');
                }
            },
            complete: function () {
                $("#LoadingModal").modal('hide');
            },
        });
    }
}

function GoToPlaybook() {
    var url = "./processes.aspx";
    $(location).attr('href', url);
}

function GoToDashboard() {
    var url = "./dashboardjsNew.aspx";
    $(location).attr('href', url);
}

function AddRefItem(ctr,newline,value) {
    var data = "";

    if (newline == true) {
       data = data.concat("<br />");
    };

    if (value == "") {
        data = data.concat("<input type='text' />");
    }
    else {
        data = data.concat("<input type='text' value='" + value + "' />");
    }

    data = data.concat("&nbsp");
    data = data.concat("<img src='img/add_icon_small.png' onclick=AddRefItem('" + ctr + "'," + true + ",''); />");

    $("#" + ctr + "").append(data);
}

function LoadPlaybookItem(playbookid) {
    var data = { playbookid: playbookid };

    $.ajax({
        beforeSend: function () {
          $("#LoadingModal").modal('show');
        },
        type: "POST",
        global: false,
        url: "../ManageUPWebService.asmx/GetPlaybookByID",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify(data),
        success: function (returnData) {
            if (returnData.d.Category1 != "") {
                $("#PlaybookCat1").val(returnData.d.Category1);
            }
            else {
                $("#PlaybookCat1").val(0);
            }

            if (returnData.d.Category2 != "") {
                $("#PlaybookCat2").val(returnData.d.Category2);
            }
            else {
                $("#PlaybookCat2").val(0);
            }

            if (returnData.d.Category3 != "") {
                $("#PlaybookCat3").val(returnData.d.Category3);
            }
            else {
                $("#PlaybookCat3").val(0);
            }

            if (returnData.d.Category4 != "") {
                $("#PlaybookCat4").val(returnData.d.Category4);
            }
            else {
                $("#PlaybookCat4").val(0);
            }

            if (returnData.d.Description != "") {
                $("#OtherCatDesc").val(returnData.d.Description);
            }

            if (returnData.d.DocumentCat3 != null) {
                var Doc3 = returnData.d.DocumentCat3.split(",");

                for (var x = 0; x < Doc3.length; x++) {
                    AddRefItem('OtherRefs', true, Doc3[x]);
                }
            }
            else {
                AddRefItem('OtherRefs', true, '');
            }

            if (returnData.d.DocumentCat4 != null) {
                var Doc4 = returnData.d.DocumentCat4.split(",");

                for (var x = 0; x < Doc4.length; x++) {
                    AddRefItem('MiscRefs', true, Doc4[x]);
                }
            }
            else {
                AddRefItem('MiscRefs', true, '');
            }

            $("#LoadingModal").modal('hide');
        },
        complete: function () {
        },
    });
}
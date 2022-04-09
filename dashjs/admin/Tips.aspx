<%@ Page Title="" Language="C#" MasterPageFile="~/MasterNewUI.Master" AutoEventWireup="true" CodeBehind="Tips.aspx.cs" Inherits="ManageUPPRM.dashjs.admin.Tips" %>
<%@ Import Namespace="ManageUPPRM.Extensions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(function () {
            //Initial Load of Tips Table
            reloadTipsTable();

            $("#tip-edition-modal").on('hide.bs.modal', function (e) {
                //Clear modal inputs
                $("#tip-edition-title").val('');
                $("#tip-edition-description").summernote('code', '');
                $("#tip-edition-modal").data("tipId", '');
                $("#tip-edition-error-container").html("");

                reloadTipsTable();
            })

            applySummernote($("#tip-edition-description"), null, null, 350);

        });

        //Edit Tip Click Handler
        $(document).on("click", ".edit-tip", function () {
            var tipID = $(this).data("tipId");
            loadEditionModal(tipID);
        });

        //Create Tip Click Handler
        $(document).on("click", "#create-tip", function () {
            loadEditionModal();
        });

        $(document).on("click", "#tip-edition-save", function () {
            var tipID = $("#tip-edition-modal").data("tipId");
            descriptionIsEmpty = $("#tip-edition-description").summernote('isEmpty');

            var data = {
                TipID: tipID,
                Title: $("#tip-edition-title").val(),
                Description: descriptionIsEmpty ? "" : $("#tip-edition-description").summernote('code')
            }

            if (ValidateTip(data)) {
                call('/ManageUPWebService.asmx/AddOrEditTip', JSON.stringify({ tip: data }), function (response) {
                    if (response.d.Success) {
                        bootbox.alert("The Tip was saved successfully");
                    }
                    else {
                        bootbox.alert("An error ocurred while trying to save the Tip");
                    }

                    $("#tip-edition-modal").modal("hide");
                }, function (response) {
                    showErrorMsgs($("#tip-edition-error-container"), "An error ocurred while retrieving the tip information.");
                });

            }
        });

        $(document).on("click", "#tip-edition-preview", function () {
            descriptionIsEmpty = $("#tip-edition-description").summernote('isEmpty');

            var tip = {
                Title: $("#tip-edition-title").val(),
                Description: descriptionIsEmpty ? "" : $("#tip-edition-description").summernote('code')
            }

            if (ValidateTip(tip)) {
                $("#tips-title").text(tip.Title);
                $(".tips-description-container").html(tip.Description);

                //Disable Previous Tip
                $("#tips-previous-button").prop('disabled', true);
                $("#tips-previous-button .fa-caret-left").hide();
                $("#tips-previous-button").removeData("tipID");

                //In case there's only ONE Tip, we need to hide one of the navigation buttons
                $("#tips-next-button").hide();
                $("#tips-next-button").hide();
                $(".show-tips-checkbox-container").hide();

                $("#tips-modal").modal("show");
            }
        });

        var ValidateTip = function (tip) {
            $("#tip-edition-error-container").html("");

            var validationErrors = [];

            if (!tip.Title) 
                validationErrors.push("The Title field is required");

            if (tip.Title.length > 100) {
                validationErrors.push("The Title field length should be less than 100 characters");
            }

            if (!tip.Description)
                validationErrors.push("The Description field is required");

            if (validationErrors.length > 0) {
                showErrorMsgs($("#tip-edition-error-container"), validationErrors);
                return false;
            }

            return true;
        }

        var reloadTipsTable = function () {
            call('/ManageUPWebService.asmx/GetTips', JSON.stringify({ includeInactive: false }), function (response) {
                tips = response.d;

                if (tips.length > 0) {
                    $("#tips-table").dataTable().fnDestroy();
                    $("#tips-table tbody").html($('#tip-template').tmpl(tips));
                    $("#tips-table").dataTable({
                        "aoColumnDefs": [
                            { "searchable": false, "targets": 2 }, //Makes Actions Column Non-Searchable
                            { "orderable": false, "targets": 2 }, //Makes Actions Column Non-Sortable
                            { "targets": 0, "sType": 'string' }
                        ]
                    });
                }
            }, function (response) {
                bootbox.alert("An error ocurred while retrieving the Tips information.");
            });
        }

        var loadEditionModal = function (tipID) {
            if (tipID) {
                var data = {
                    tipID: tipID
                }

                call('/ManageUPWebService.asmx/GetTip', JSON.stringify(data), function (response) {
                    tip = response.d;

                    if (tip) {
                        //Load Current Tip
                        $("#tip-edition-title").val(tip.Title);
                        $("#tip-edition-description").summernote('code', tip.Description);
                    }
                }, function (response) {
                    showErrorMsgs($("#tip-edition-error-container"), "An error ocurred while retrieving the tip information.");
                });

                $("#tip-edition-modal").data("tipId", tipID);
            }
            
            $("#tip-edition-modal").modal("show");
        }
    </script>

    <style>

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="page-content-wrapper">
        <div class="page-content">
            <div class="row-fluid">

                <%--Admin Menu--%>
                <div class="portlet light bordered" data-team="false">
                    <div class="portlet-title " style="border: none;">
                        <div class="tabbable-line col-md-9">
                            <ul class="nav nav-tabs home-tabs nav-justified task-widget" id="AdminTabs">
                                <asp:Literal ID="AdminMenu" runat="server" />
                            </ul>
                        </div>
                    </div>
                </div>
            
                <%--Page Title--%>
                <h3 class="page-title">
                    Tips Of The Week <small>Manage And Create Weekly Tips To Help Users To Get To Know The Different Features Of The Application</small>
                </h3>

                <%--Content--%>
                <div class="portlet portlet light bordered">
                    <div class="portlet-body">
                        <button type="button" class="btn btn-success bottom-padding" id="create-tip"><i class="fa fa-plus"></i> Create</button>
                        <table id="tips-table" class="table table-bordered table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>Creation Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%--Tip Template--%>
    <script type="text/x-jquery-tmpl" id="tip-template">
        <tr>
            <td>${Title}</td>
            <td>${CreationDateAsShortDateString}</td>
            <td>
                <a href="#" class="edit-tip" data-tip-id="${TipID}"><i class="fa fa-pencil"></i> Edit</a>
            </td>
        </tr>
    </script>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="modals" runat="server">
    <div class="modal fade bs-modal-lg" id="tip-edition-modal">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-content">
                    <div class="modal-header">
                        Tip Of The Week
                    </div>
                    <div class="modal-body">
                        <div id="tip-edition-error-container"></div>
                        <div class="form form-horizontal" role="form">
                            <div class="form-body">
                                <div class="control-group">
                                    <div class="form-group">
                                        <label class="control-label col-md-2" for="footer-html">Title</label>
                                        <div class="col-md-10">
                                            <input type="text" class="form-control col-md-10" id="tip-edition-title" maxlength="100"/>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-md-2" for="footer-html">Description</label>
                                        <div class="col-md-10">
                                            <textarea class="form-control" id="tip-edition-description" rows="4"></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-info" id="tip-edition-preview">Preview</button>
                        <button type="button" class="btn btn-info" id="tip-edition-save">Save</button>
                        <button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
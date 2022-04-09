<%@ Page Title="" Language="C#" MasterPageFile="~/MasterNewUI.Master" AutoEventWireup="true" CodeBehind="ProductUpdates.aspx.cs" Inherits="ManageUPPRM.dashjs.admin.ProductUpdates" %>
<%@ Import Namespace="ManageUPPRM.Extensions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(function () {
            //Initial Load of ProductUpdates Table
            reloadProductUpdatesTable();

            $("#product-update-edition-version").inputmask("9.9.9", {
                "onincomplete": function () {
                    $(this).val($(this).val().replace(/\_/g, '0')); //If the user does not complete the version number, we complete it with zeroes
                }
            });

            $("#product-update-edition-modal").on('hide.bs.modal', function (e) {
                //Clear modal inputs
                $("#product-update-edition-title").val('');
                $("#product-update-edition-version").val('');
                $("#product-update-edition-description").summernote('code', '');
                $("#product-update-edition-modal").data("productUpdateId", '');
                $("#product-update-edition-error-container").html("");

                reloadProductUpdatesTable();
            })

            applySummernote($("#product-update-edition-description"), null, null, 350);

        });

        //Edit Product Update Click Handler
        $(document).on("click", ".edit-product-update", function () {
            var productUpdateID = $(this).data("productUpdateId");
            loadEditionModal(productUpdateID);
        });

        //Create Product Update Click Handler
        $(document).on("click", "#create-product-update", function () {
            loadEditionModal();
        });

        $(document).on("click", "#product-update-edition-save", function () {
            var productUpdateID = $("#product-update-edition-modal").data("productUpdateId");
            descriptionIsEmpty = $("#product-update-edition-description").summernote('isEmpty');

            var data = {
                ProductUpdateID: productUpdateID,
                Title: $("#product-update-edition-title").val(),
                Version: $("#product-update-edition-version").val(),
                Description: descriptionIsEmpty ? "" : $("#product-update-edition-description").summernote('code')
            }

            if (ValidateProductUpdate(data)) {
                call('/ManageUPWebService.asmx/AddOrEditProductUpdate', JSON.stringify({ productUpdate: data }), function (response) {
                    if (response.d.Success) {
                        bootbox.alert("The Product Update was saved successfully");
                    }
                    else {
                        bootbox.alert("An error ocurred while trying to save the Product Update");
                    }

                    $("#product-update-edition-modal").modal("hide");
                }, function (response) {
                    showErrorMsgs($("#product-update-edition-error-container"), "An error ocurred while retrieving the update information.");
                });

            }
        });

        $(document).on("click", "#product-update-edition-preview", function () {
            descriptionIsEmpty = $("#product-update-edition-description").summernote('isEmpty');

            var productUpdate = {
                Title: $("#product-update-edition-title").val(),
                Version: $("#product-update-edition-version").val(),
                Description: descriptionIsEmpty ? "" : $("#product-update-edition-description").summernote('code')
            }

            if (ValidateProductUpdate(productUpdate)) {
                $(".product-updates-version").text(productUpdate.Version);
                $("#product-updates-title").text(productUpdate.Title);
                $(".product-updates-description-container").html(productUpdate.Description);

                //Disable Previous Update
                $("#product-updates-previous-version-button").prop('disabled', true);
                $("#product-updates-previous-version-button .fa-caret-left").hide();
                $("#product-updates-previous-version-button").removeData("productUpdateID");
                $(".product-updates-previous-version").text(productUpdate.Version);

                //In case there's only ONE ProductUpdate, we need to hide one of the navigation buttons
                $("#product-updates-next-version-button").hide();

                //We scroll up the modal
                //$('#product-updates-modal .modal-body').slimScroll({ scrollTo: '0px' });

                $("#product-updates-modal").modal("show");
            }
        });

        var ValidateProductUpdate = function (productUpdate) {
            $("#product-update-edition-error-container").html("");

            var validationErrors = [];

            if (!productUpdate.Title) 
                validationErrors.push("The Title field is required");

            if (productUpdate.Title.length > 100) {
                validationErrors.push("The Title field length should be less than 100 characters");
            }

            if (!productUpdate.Version) {
                validationErrors.push("The Version field is required");
            } else {
                if (!$.inputmask.isValid(productUpdate.Version, { mask: "9.9.9" })) {
                    validationErrors.push("The Version field does not respect the expected format");
                }
            }

            if (!productUpdate.Description)
                validationErrors.push("The Description field is required");

            if (validationErrors.length > 0) {
                showErrorMsgs($("#product-update-edition-error-container"), validationErrors);
                return false;
            }

            return true;
        }

        var reloadProductUpdatesTable = function () {
            call('/ManageUPWebService.asmx/GetProductUpdates', JSON.stringify({ includeInactive: false }), function (response) {
                productUpdates = response.d;

                if (productUpdates.length > 0) {
                    $("#product-updates-table").dataTable().fnDestroy();
                    $("#product-updates-table tbody").html($('#product-update-template').tmpl(productUpdates));
                    $("#product-updates-table").dataTable({
                        "aoColumnDefs": [
                            { "searchable": false, "targets": 3 }, //Makes Actions Column Non-Searchable
                            { "orderable": false, "targets": 3 }, //Makes Actions Column Non-Sortable
                            { "targets": 0, "sType": 'string' }, //Makes Actions Column Non-Searchable
                        ],
                        "order": [[0, "desc"]] //Sets table default sorting column (Version Int)
                    });
                }
            }, function (response) {
                bootbox.alert("An error ocurred while retrieving the Product Updates information.");
            });
        }

        var loadEditionModal = function (productUpdateID) {
            if (productUpdateID) {
                var data = {
                    productUpdateID: productUpdateID
                }

                call('/ManageUPWebService.asmx/GetProductUpdate', JSON.stringify(data), function (response) {
                    productUpdate = response.d;

                    if (productUpdate) {
                        //Load Current Update
                        $("#product-update-edition-title").val(productUpdate.Title);
                        $("#product-update-edition-version").val(productUpdate.Version);
                        $("#product-update-edition-description").summernote('code', productUpdate.Description);
                    }
                }, function (response) {
                    showErrorMsgs($("#product-update-edition-error-container"), "An error ocurred while retrieving the update information.");
                });

                $("#product-update-edition-modal").data("productUpdateId", productUpdateID);
            }
            
            $("#product-update-edition-modal").modal("show");
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
                    Product Updates <small>Manage Product Updates To Inform Users About New Features And Changes On The Application</small>
                </h3>

                <%--Content--%>
                <div class="portlet portlet light bordered">
                    <div class="portlet-body">
                        <button type="button" class="btn btn-success bottom-padding" id="create-product-update"><i class="fa fa-plus"></i> Create</button>
                        <table id="product-updates-table" class="table table-bordered table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>Version</th>
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

    <%--Product Update Template--%>
    <script type="text/x-jquery-tmpl" id="product-update-template">
        <tr>
            <td>${Version}</td>
            <td>${Title}</td>
            <td>${CreationDateAsShortDateString}</td>
            <td>
                <a href="#" class="edit-product-update" data-product-update-id="${ProductUpdateID}"><i class="fa fa-pencil"></i> Edit</a>
            </td>
        </tr>
    </script>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="modals" runat="server">
    <div class="modal fade bs-modal-lg" id="product-update-edition-modal">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-content">
                    <div class="modal-header">
                        Product Update
                    </div>
                    <div class="modal-body">
                        <div id="product-update-edition-error-container"></div>
                        <div class="form form-horizontal" role="form">
                            <div class="form-body">
                                <div class="control-group">
                                    <div class="form-group">
                                        <label class="control-label col-md-2" for="footer-html">Title</label>
                                        <div class="col-md-10">
                                            <input type="text" class="form-control col-md-10" id="product-update-edition-title" maxlength="100"/>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-md-2" for="footer-html">Version</label>
                                        <div class="col-md-10">
                                            <input type="text" class="form-control col-md-10" id="product-update-edition-version" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-md-2" for="footer-html">Description</label>
                                        <div class="col-md-10">
                                            <textarea class="form-control" id="product-update-edition-description" rows="4"></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-info" id="product-update-edition-preview">Preview</button>
                        <button type="button" class="btn btn-info" id="product-update-edition-save">Save</button>
                        <button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

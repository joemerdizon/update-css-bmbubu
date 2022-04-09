<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterNewUi.Master" CodeBehind="Categories.aspx.cs" Inherits="ManageUPPRM.dashjs.admin.Categories" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $('#categories-table').dataTable({
                "aoColumnDefs": [
                    { "searchable": false, "targets": 1 }
                ]
            });

            $('#subcategories-table').dataTable({
                "aoColumnDefs": [
                    { "searchable": false, "targets": 2 }
                ]
            });

            $('body').on('click', '.archive-button', function () {
                var category = $(this);
                call('categories.aspx/ArchiveOrUnarchiveCategory', JSON.stringify({ categoryID: $(this).data('id') }), function () {
                    var row = category.closest('tr');
                    row.toggleClass('warning');
                    category.text(row.hasClass('warning') ? 'Unarchive' : 'Archive');
                });

                return false;
            });
        });
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-content-wrapper">
        <div class="page-content">

            <h3 class="hide-on-content-only page-title">Categories and Subcategories</h3>

            <div class="page-bar hide-on-content-only">
                <ul class="page-breadcrumb">
                    <li class="ms-hover">
                        <i class="fa fa-home"></i>
                        <a href="settings.aspx">Settings</a>
                        <i class="fa fa-angle-right"></i>
                    </li>
                    <li class="ms-hover">
                        <a href="#">Categories and Subcategories</a>
                    </li>
                </ul>
            </div>

            <div class="row">
                <div class="col-md-6" id="clients-container">
                    <asp:DropDownList ID="ClientList" runat="server" CssClass="form-control" AppendDataBoundItems="true" AutoPostBack="true">
                    </asp:DropDownList>
                </div>
            </div>

            <div class="row margin-top-20">
                <div class="portlet box green bordered" data-team="false">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="fa fa-bullseye"></i>
                            <span>Categories</span>
                        </div>
                    </div>
                    <div class="portlet-body" style="position: relative;">
                        <div class="table-container">
                            <table id="categories-table" class="table table-striped table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th>Category</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Literal runat="server" ID="categoriesRows"></asp:Literal>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="portlet box green bordered" data-team="false">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="fa fa-bullseye"></i>
                            <span>Subcategories</span>
                        </div>
                    </div>
                    <div class="portlet-body" style="position: relative;">
                        <div class="table-container">
                            <table id="subcategories-table" class="table table-striped table-bordered table-hover">
                                <thead>
                                    <asp:Literal runat="server" ID="subcategoriesHeader"></asp:Literal>
                                </thead>
                                <tbody>
                                    <asp:Literal runat="server" ID="subcategoriesRows"></asp:Literal>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="modals" runat="server">
</asp:Content>

<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterNewUi.Master" CodeBehind="Category.aspx.cs" Inherits="ManageUPPRM.dashjs.admin.Category" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {

        });

    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-content-wrapper">
        <div class="page-content">

            <h3 class="hide-on-content-only page-title">Category</h3>

            <div class="page-bar hide-on-content-only">
                <ul class="page-breadcrumb">
                    <li class="ms-hover">
                        <i class="fa fa-home"></i>
                        <a href="settings.aspx">Settings</a>
                        <i class="fa fa-angle-right"></i>
                    </li>
                    <li class="ms-hover">
                        <i class="fa fa-home"></i>
                        <a href="categories.aspx">Categories and Subcategories</a>
                        <i class="fa fa-angle-right"></i>
                    </li>
                    <li class="ms-hover">
                        <a href="#">Category</a>
                    </li>
                </ul>
            </div>

            <div class="row margin-top-20">
                <div class="portlet light bordered" data-team="false">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="fa fa-bullseye"></i>
                            <span>Categories</span>
                        </div>
                    </div>
                    <div class="portlet-body form" style="position: relative;">
                        <asp:HiddenField runat="server" ID="ID" />
                        <div class="form-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Name</label>
                                        <div class="col-md-9">
                                            <asp:TextBox ID="Name" CssClass="form-control" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-actions">
                                <asp:Button ID="Save" runat="server" Text="Save" OnClick="Save_Click" CssClass="btn green" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="modals" runat="server">
</asp:Content>

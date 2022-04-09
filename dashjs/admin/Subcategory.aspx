<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterNewUi.Master" CodeBehind="Subcategory.aspx.cs" Inherits="ManageUPPRM.dashjs.admin.Subcategory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {

        });

    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-content-wrapper">
        <div class="page-content">

            <h3 class="hide-on-content-only page-title">Subcategory</h3>

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
                        <a href="#">Subcategory</a>
                    </li>
                </ul>
            </div>

            <div class="row margin-top-20">
                <div class="portlet light bordered">
                    <div class="portlet-title">
                        <div class="caption">
                            <span>Subcategory</span>
                        </div>
                    </div>
                    <div class="portlet-body" style="position: relative;">
                        <div class="portlet-body form">
                            <asp:HiddenField runat="server" ID="subCategoryID" />
                            <asp:HiddenField runat="server" ID="parentID" />

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
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="control-label col-md-3">Parent</label>
                                            <div class="col-md-9">
                                                <asp:DropDownList ID="parentCategory" CssClass="form-control" runat="server"></asp:DropDownList>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <asp:Panel runat="server" ID="PointsContent">
                                    <h3 class="form-section">Points</h3>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="control-label col-md-3">Safety</label>
                                                <div class="col-md-9">
                                                    <asp:TextBox ID="Safety" CssClass="form-control" runat="server"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="control-label col-md-3">Quality</label>
                                                <div class="col-md-9">
                                                    <asp:TextBox ID="Quality" CssClass="form-control" runat="server"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="control-label col-md-3">Efficency</label>
                                                <div class="col-md-9">
                                                    <asp:TextBox ID="Efficency" CssClass="form-control" runat="server"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="control-label col-md-3">Effectiveness</label>
                                                <div class="col-md-9">
                                                    <asp:TextBox ID="Effectiveness" CssClass="form-control" runat="server"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="control-label col-md-3">Zest</label>
                                                <div class="col-md-9">
                                                    <asp:TextBox ID="Zest" CssClass="form-control" runat="server"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>
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

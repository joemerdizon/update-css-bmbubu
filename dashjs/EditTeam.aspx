<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="static" MasterPageFile="~/MasterNewUi.Master"  CodeBehind="EditTeam.aspx.cs" Inherits="ManageUPPRM.dashjs.EditTeam" %>

<%@ Register TagPrefix="uc" TagName="UsersGroup" Src="~/UserControls/UsersGroup.ascx" %>
<%@ Register TagPrefix="uc" TagName="UsersGroupModal" Src="~/UserControls/UsersGroupModal.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <link href="../dashjs/css/kendo.common.min.css" rel="stylesheet" />
    <link href="../dashjs/css/kendo.default.min.css" rel="stylesheet" />

    <script src="js/Kendo.all.min.js"></script>
    <script src="../dashjs/js/fuelUx/scheduler.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
        });
    </script>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="modals" runat="server">
    <uc:UsersGroupModal runat="server" ID="UsersGroupModal"></uc:UsersGroupModal>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">





    <div class="page-content-wrapper">
        <div class="page-content">






                <div class="portlet box green main-form">
                <div class="portlet-title">
                    <div class="caption">
                        <i class="fa fa-users"></i>
                        <span>Team</span>
                    </div>
                </div>
                <div class="portlet-body form">
                    <div class="form-body">
                        <h3 class="form-section">Team Information</h3>

                        <div class="row margin-bottom-20">
                            <div class="col-md-6">
                                <label class="control-label col-md-4">Name</label>
                                <div class="col-md-8">
                                    <asp:TextBox ID="TeamName" runat="server" ClientIDMode="Static"  CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="control-label col-md-4">Description</label>
                                <div class="col-md-8">
                                    <asp:TextBox ID="TeamDescription" runat="server" ClientIDMode="Static" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row margin-top-20">
                            <div class="col-md-6">
                                <label class="control-label col-md-4">Team Lead</label>
                                <div class="col-md-8">
                                    <select runat="server" id="cmbManager" class="form-control"></select>
                                </div>
                            </div>
                        </div>
                        <div class="row margin-top-20">
                            <div class="col-md-6">
                                <label class="control-label col-md-4">Active</label>
                                <div class="col-md-8">
                                    <div class="top-padding">
                                        <input type="checkbox" runat="server" id="chkActive" class="form-control"></input>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row margin-top-20">
                                <label class="control-label col-md-2">Members</label>
                                <div class="col-md-9">
                                    <uc:UsersGroup runat="server" ID="Assignee" />
                                </div>
                        </div>
                    </div>
                    <div class="form-actions">
                        <asp:Button ID="SaveTeam" runat="server" Text="Save Team" CssClass="btn green" OnClick="SaveTeam_Click" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>



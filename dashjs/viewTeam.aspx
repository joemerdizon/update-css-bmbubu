<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterNewUi.Master" CodeBehind="viewTeam.aspx.cs" Inherits="ManageUPPRM.dashjs.viewTeam" %>


<%@ Register TagPrefix="uc" TagName="SqueezeViewerModal" Src="~/UserControls/SqueezeViewerModal.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            loadTeamMembers();
            useDashInstedOfEmptyContent();
        });

        function loadTeamMembers() {
            $('#teamMembers').html($('#team-row-content').tmpl(members));
            $('#teamLead').html($('#team-row-content').tmpl(teamLead));
            applyTooltip($('#teamMembers .withTooltip'));

            $('.show-squeeze').on('click', function () {
                showSqueezeModal($(this).data('userid'), $(this).data('name'));
                return false;
            });
        };

    </script>
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
                                <label class="control-label col-md-4">Team Name</label>
                                <div class="col-md-8">
                                    <p class="form-control-static" id="txtTeamName" runat="server"></p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="control-label col-md-4">Team Description</label>
                                <div class="col-md-8">
                                    <p class="form-control-static" id="txtTeamDescription" runat="server"></p>
                                </div>
                            </div>
                        </div>
                        <div class="row margin-top-20">
                            <label class="control-label col-md-2">Team Lead</label>
                            <div class="col-md-8">
                                <ul id="teamLead" class="team-members-list">
                                </ul>
                            </div>
                        </div>
                        <div class="row margin-top-20">
                            <label class="control-label col-md-2">Members</label>
                            <div class="col-md-8">
                                <ul id="teamMembers" class="team-members-list">
                                </ul>
                            </div>
                        </div>
                    </div>
                    <asp:PlaceHolder runat="server" ID="editContainer">
                        <div class="form-actions">
                            <div class="row">
                                <div class="col-md-6">
                                    <a href="EditTeam.aspx?TeamID=<%=this.TeamID%>" class="btn green">
                                        <i class="fa fa-pencil"></i>&nbsp;Edit
                                    </a>
                                </div>
                            </div>
                        </div>
                    </asp:PlaceHolder>
                </div>
            </div>
        </div>
    </div>

    <script type="text/x-jquery-tmpl" id="team-row-content">
        <li>
            <div class="team-member-container">
                <span class="photo">
                    <img src="${profilePicture}" class="img-circle" onerror="loadDefaultImage(this);" alt="" />
                </span>
                <span class="subject">
                    <span class="from">${name} </span>
                    <span class="message">
                        <a href="mailto:${email}"><i class="fa fa-envelope"></i></a>
                        <a href="tel:${telephone}" data-original-title="${telephone}" class="withTooltip"><i class="fa fa-phone"></i></a>
                        <a href="tasks.aspx?action=All&team=True&user=${name}"><i class="fa fa-bullseye"></i></a>
                        <a href="#" class="show-squeeze" data-userid="${ID}" data-name="${name}"><i class="fa fa-star"></i></a>
                    </span>
                </span>
            </div>
        </li>
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="modals" runat="server">
    <uc:SqueezeViewerModal runat="server" ID="SqueezeViewerModal"></uc:SqueezeViewerModal>
</asp:Content>
<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="static" MasterPageFile="~/MasterNewUi.Master" CodeBehind="Team.aspx.cs" Inherits="ManageUPPRM.dashjs.Team" %>

<%@ Register TagPrefix="uc" TagName="SqueezeViewerModal" Src="~/UserControls/SqueezeViewerModal.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var aspxPage = 'team.aspx';
        var teamsSelectedTab = $.cookie("TeamPageTeamListSelectedTab") ? $.cookie("TeamPageTeamListSelectedTab") : 'My Teams';
        var contactsSelectedTab = $.cookie("TeamPageContactListSelectedTab") ? $.cookie("TeamPageContactListSelectedTab") : 'Contacts';

        $(document).ready(function () {
            getTeams('My Teams');
            getContacts('Contacts');

            $(".nav-tabs li").on('show.bs.tab', function (e) {
                //var container = $($(e.target).attr("href"));
                
                var type = $(this).data('action');

                if (type=='Favorite Contacts' || type=='Contacts')
                {
                    $.cookie("TeamPageContactListSelectedTab", type);
                    getContacts(type);
                }
                else
                {
                    $.cookie("TeamPageTeamListSelectedTab", type);
                    getTeams(type);
                }
            });

            $("#chkIncludeInactiveContacts").click(function(){
                getContacts(contactsLastType);
            });

            $("li[data-action='" + teamsSelectedTab + "'] a").click();
            $("li[data-action='" + contactsSelectedTab + "'] a").click();
        });

        function doContactFavorite(userId) {
            var checkbox = $('#chkContactFav' + userId);
            var isChecked = checkbox.is(":checked");
            var params = '{ userId : ' + userId + ', isFavorite: ' + isChecked + ' }';
            call(aspxPage + '/doContactFavorite', params, function(){
                getContacts(contactsLastType);
            });
        }

        function doFavorite(teamId) {
            var checkbox = $('#chkFav' + teamId);
            var isChecked = checkbox.is(":checked");

            var params = '{ teamId : ' + teamId + ', isFavorite: ' + isChecked + ' }';
            call(aspxPage + '/doFavorite', params, function(){
                getTeams(lastType);
            });
        };

        var lastType;
        function getTeams(type) {
            lastType = type;

            var checkboxArchived = $('#chkIncludeArchived');
            var isChecked = checkboxArchived.is(":checked");

            $('#teamRows').html('');
            if (type == 'Favorites') { onlyFavorites = 'true'; onlyMine = 'false' }
            if (type == 'All Teams') { onlyFavorites = 'false'; onlyMine = 'false' }
            if (type == 'My Teams') { onlyFavorites = 'false'; onlyMine = 'true' }

            var archived = 'false';
            if (isChecked) archived = 'true'
            var params = '{ onlyFavorites: ' + onlyFavorites + ', onlyMine: ' + onlyMine + ', archived: ' + archived + ' }';
            var contacts = call(aspxPage + '/getTeams', params, processTeams);

        };

        var contactsLastType;
        function getContacts(type) {
            contactsLastType = type;

            var showInactiveContacts = $('#chkIncludeInactiveContacts').is(":checked");

            var oFavorites = false;
            if (type=='Favorite Contacts') 
                oFavorites = true;

            var params = { 
                onlyFavorites: oFavorites ,
                includeInactive: showInactiveContacts
            };

            var teams = call(aspxPage + '/getContacts', JSON.stringify(params), processContacts);
        };

        function processTeams(result) {
            var table = $('#tabTeams');
            if (table.hasClass('dataTable')) {
                table.DataTable().destroy();
            };

            $('#teamRows').html($('#team-row-content').tmpl(result.d));

            table.DataTable({ stateSave: true });

        };

        function processContacts(result) {

            var table = $('#tabContacts');
            if (table.hasClass('dataTable')) {
                table.DataTable().destroy();
            };

            $('#contactRows').html($('#contact-row-content').tmpl(result.d));

            table.DataTable({ stateSave: true });

            applyTooltip($('#contactRows .withTooltip'));

            $('#contactRows').on('click', '.show-squeeze',function () {
                showSqueezeModal($(this).data('userid'), $(this).data('name'));
                return false;
            });

        };

    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-content-wrapper">
        <div class="page-content">

            <asp:PlaceHolder runat="server" ID="createContainer">
                <div class="row">
                    <div class="col-md-6">
                        <a class="btn green show-loading" href="editTeam.aspx">Create&nbsp;
                            <i class="fa fa-plus"></i>
                        </a>
                    </div>
                </div>
                <div class="row" runat="server" id="divArchived">
                    <div class="col-md-6">
                        <div class="portlet-body">
                                    <br />
                                    <input type="checkbox" ID="chkIncludeArchived" onclick="getTeams(lastType);" /> Include archived teams
                        </div>
                    </div>
                </div>

            </asp:PlaceHolder>
            <div class="row margin-top-20">
                <div class="portlet light bordered" data-team="false">
                    <div class="portlet-title " style="border: none;">
                        <div class="tabbable-line col-md-9">
                            <ul class="nav nav-tabs home-tabs nav-justified task-widget">
                                <li data-action="Favorites">
                                    <a href="#UrgentTabContent" data-toggle="tab">Favorite Teams</a>
                                </li>

                                <li class="active" data-action="My Teams">
                                    <a href="#UrgentTabContent" data-toggle="tab">My Teams</a>
                                </li>

                                <asp:PlaceHolder runat="server" ID="allTeamsTab">
                                    <li data-action="All Teams">
                                        <a href="#UrgentTabContent" data-toggle="tab">All Teams</a>
                                    </li>
                                </asp:PlaceHolder>
                            </ul>
                        </div>
                        <div class="col-md-3 tools text-right">
                        </div>
                    </div>
                    <div class="portlet-body" style="position: relative;">
                        <div class="tab-content">
                            <div class="tab-pane active" id="UrgentTabContent">
                                <div class="table-container">
                                    <table id="tabTeams" class="table table-striped table-bordered table-hover">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Team Lead</th>
                                                <th>Members</th>
                                                <th>Favorite</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody id="teamRows">
                                        </tbody>
                                    </table>
                                </div>
                                <div class="loading-container"></div>
                            </div>
                        </div>
                    </div>
                </div>



                
                <div class="row" runat="server" id="div1">
                    <div class="col-md-6" style="margin-left: 15px;">
                        <div class="portlet-body">
                            <input type="checkbox" id="chkIncludeInactiveContacts" /> Include inactive contacts
                        </div>
                        <br />
                    </div>
                </div>

                <div class="portlet light bordered" data-team="false">
                    <div class="portlet-title " style="border: none;">
                        <div class="tabbable-line col-md-9">
                            <ul class="nav nav-tabs home-tabs nav-justified task-widget">
                                <li class="active" data-action="Contacts">
                                    <a href="#UrgentTabContent" data-toggle="tab">Contacts</a>
                                </li>

                                <li data-action="Favorite Contacts">
                                    <a href="#UrgentTabContent" data-toggle="tab">Favorite Contacts</a>
                                </li>
                            </ul>
                        </div>
                        <div class="col-md-3 tools text-right">
                        </div>
                    </div>
                    <div class="portlet-body" style="position: relative;">
                        <div class="tab-content">
                            <div class="tab-pane active" id="UrgentTabContent">
                                <div class="table-container">
                                    <table id="tabContacts" class="table table-striped table-bordered table-hover">
                                        <thead>
                                            <tr>
                                                <th></th>
                                                <th>Name</th>
                                                <th>Department</th>
                                                <th></th>
                                                <th>Favorite</th>
                                            </tr>
                                        </thead>
                                        <tbody id="contactRows">
                                        </tbody>
                                    </table>
                                </div>
                                <div class="loading-container"></div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <script type="text/x-jquery-tmpl" id="team-row-content">
                <tr class="{{if Archive == true }}warning{{/if}}">
                    <td>${Name}</td>
                    <td>${ManagerName}</td>
                    <td title="${MembersNames}">${MembersNumber}</td>
                    <td><input type="checkbox" id="chkFav${TeamId}" {{if isFavorite == true }} checked  {{/if}} onclick="doFavorite(${TeamId});" /></td>
                    <td>
                        <%=this.createEditPermission ? "<a href='editTeam.aspx?teamId=${TeamId}'>Edit&nbsp;</a>" : string.Empty%>
                        <a href="viewTeam.aspx?teamId=${TeamId}">View</a>
                    </td>
                </tr>
            </script>

            <script type="text/x-jquery-tmpl" id="contact-row-content">
                <tr class="{{if !active}}warning{{/if}}">
                    <td><img src="${profilePicture}" class="img-circle" style="max-width: 40px; max-height: 40px" alt="" onerror="loadDefaultImage(this);" /></td>
                    <td>${name}</td>
                    <td>${department}</td>
                    <td>
                        <a href="mailto:${email}"><i class="fa fa-envelope"></i></a>
                        <a href="tel:${telephone}" data-original-title="${telephone}" class="withTooltip marL10"><i class="fa fa-phone"></i></a>
                        <a href="tasks.aspx?action=All&team=True&user=${name}" class="marL10"><i class="fa fa-bullseye"></i></a>
                        <a href="#" class="show-squeeze marL10" data-userid="${ID}" data-name="${name}"><i class="fa fa-star"></i></a>
                    </td>
                    <td><input type="checkbox" id="chkContactFav${ID}" {{if isFavorite == true }} checked  {{/if}} onclick="doContactFavorite(${ID});" /></td>

                </tr>
            </script>


        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="modals" runat="server">
    <uc:SqueezeViewerModal runat="server" ID="SqueezeViewerModal"></uc:SqueezeViewerModal>
</asp:Content>
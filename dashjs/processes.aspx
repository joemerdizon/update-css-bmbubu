<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="static" MasterPageFile="~/MasterNewUI.Master" CodeBehind="processes.aspx.cs" Inherits="ManageUPPRM.dashjs.processes" %>

<%@ Register TagPrefix="uc" TagName="UsersGroup" Src="~/UserControls/UsersGroup.ascx" %>
<%@ Register TagPrefix="uc" TagName="UsersGroupModal" Src="~/UserControls/UsersGroupModal.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script src="/dashjs/js/processes.js"></script>

    <script src="/assets/global/plugins/jstree/dist/jstree.min.js"></script>
    <script src="/assets/admin/pages/scripts/ui-tree.js"></script>

    <link rel="stylesheet" type="text/css" href="/assets/global/plugins/jstree/dist/themes/default/style.min.css" />

    <script type="text/javascript">
        var _links;
        var queryStringPlaybookDocumentID ='<%=Request.QueryString["PlaybookDocumentID"]%>';
        
        var DocumentPermissionsViewUsersGroup;
        var DocumentPermissionsEditUsersGroup;

        function loadContentTab(nodeId, refresh) {
            doCollapseAll();

            var exist = document.getElementById('document' + nodeId);
            var contentContainer = document.getElementById('divDocumentContainer');
            applySummernote($('#txtDocumentDescription'));

            if ((exist != null) && (!refresh)) {
                contentContainer.removeChild(exist);
                contentContainer.insertBefore(exist, contentContainer.firstChild);

                exist.style.display = 'inline';
                doOpen(nodeId);
                return;
            }

            var clonedDiv;

            if (!refresh) {
                var objClone = document.getElementById('divDocumentToClone'); //$('#divDocumentToClone');
                clonedDiv = objClone.cloneNode(true);
                clonedDiv.style.display = 'inline';
                clonedDiv.id = 'document' + nodeId;
                contentContainer.insertBefore(clonedDiv, contentContainer.firstChild);

            }
            else {
                clonedDiv = exist;
            }

            var data = callActionOnServer('getNodeInfo', '{ nodeId: "' + nodeId.toString() + '" }', function (res) {
                data = res.d;
                if (data != null) {
                    _links = data.links;

                    loadElementsByDataObject(data, nodeId, clonedDiv);
                }
            });
        };

        function loadCategoryContentTab(nodeId, refresh) {
            doCollapseAll();

            var exist = document.getElementById('category' + nodeId);
            var contentContainer = document.getElementById('divDocumentContainer');

            if ((exist != null) && (!refresh)) {
                contentContainer.removeChild(exist);
                contentContainer.insertBefore(exist, contentContainer.firstChild);

                exist.style.display = 'inline';
                doOpen(nodeId);
                return;
            }

            var clonedDiv;

            if (!refresh) {
                var objClone = document.getElementById('divCategoryToClone'); //$('#divDocumentToClone');
                clonedDiv = objClone.cloneNode(true);
                clonedDiv.style.display = 'inline';
                clonedDiv.id = 'category' + nodeId;
                contentContainer.insertBefore(clonedDiv, contentContainer.firstChild);

            }
            else {
                clonedDiv = exist;
            }

            var data = callActionOnServer('GetCategoryPermissions', JSON.stringify({ categoryID: getIDFromNodeID(nodeId) }), function (res) {
                data = res.d;
                if (data != null) {
                    var name = clonedDiv.getElementsByClassName('divDocumentName')[0];
                    name.innerHTML = data.CategoryName

                    $(clonedDiv).find('.sharingInformationOwner').text(data.OwnerName);
                    $(clonedDiv).find('.sharingInformationViewers').text(data.ViewersDescription ? data.ViewersDescription : '(None)');
                    $(clonedDiv).find('.sharingInformationEditors').text(data.EditorsDescription ? data.EditorsDescription : '(None)');

                    truncateFields();
                    
                    var divDocumentBody = clonedDiv.getElementsByClassName('divDocumentBody')[0];
                    divDocumentBody.id = 'documentBody' + nodeId;

                    var butCollapse = clonedDiv.getElementsByClassName('butCollapse')[0];
                    butCollapse.id = 'butCollapse' + nodeId;

                    var butHide = clonedDiv.getElementsByClassName('butHide')[0];
                    butHide.id = 'butHide' + nodeId;
                    
                    var butRefresh = clonedDiv.getElementsByClassName('butRefresh')[0];
                    butRefresh.id = 'butRefresh' + nodeId;

                    doOpen(nodeId);
                }
            });
        };

        function openTabAlreadyLoaded() {
            var nodeId = $(this).data('nodeid');

            callActionOnServer('getNodeInfo', '{ nodeId: "' + nodeId + '" }', function (res) {
                var data = res.d;
                loadElementsByDataObject(data);
            });
        };

        function loadElementsByDataObject(data, nodeId, object) {
            elementModifyId = data.ID;
            elementType = 'D';
            elementName = data.name;
            elementDescription = data.description;
            documentLink = data.link;
            lastNodeAction = 'butFavorite' + nodeId;

            window.setTimeout("showIsFavorite(" + data.isFavorite + ");", 500);

            object.setAttribute('data-name', elementName);
            object.setAttribute('data-description', elementDescription);
            object.setAttribute('data-link', documentLink);
            object.setAttribute('data-document-type', data.DocumentTypeID);
            object.setAttribute('data-document-id', data.ID);

            var objName = object.getElementsByClassName('divDocumentName')[0];
            var objDescription = object.getElementsByClassName('divDocumentDescription')[0];

            //var objVideo = object.getElementsByClassName('divDocumentVideo')[0]; 
            var butFavorite = object.getElementsByClassName('butFavorite')[0];
            var butEdit = object.getElementsByClassName('butEdit')[0];
            var butOpenDoc = object.getElementsByClassName('butOpenDoc')[0];
            var butRefresh = object.getElementsByClassName('butRefresh')[0];
            var butCollapse = object.getElementsByClassName('butCollapse')[0];
            var butHide = object.getElementsByClassName('butHide')[0];
            var tableLinks = object.getElementsByClassName('TableLinksClass')[0];
            

            $(object).find('.sharingInformationOwner').text(data.OwnerName);
            $(object).find('.sharingInformationViewers').text(data.ViewersDescription ? data.ViewersDescription : '(None)');
            $(object).find('.sharingInformationEditors').text(data.EditorsDescription ? data.EditorsDescription : '(None)');

            truncateFields();
            
            if (data.Editors) {
                var editors = data.Editors.split(',');
            } else {
                var editors = [];
            }

            editors.push(data.Owner.toString());
            
            var isEditor = $.inArray('<%=getUserId()%>', editors) != -1
            var isAdmin = <%=roleId%> > 3;
            var canEdit = isEditor || isAdmin;

            if (!canEdit) 
                $(butEdit).remove();

            var divDocumentBody = object.getElementsByClassName('divDocumentBody')[0];
            divDocumentBody.id = 'documentBody' + nodeId;

            tableLinks.id = 'TableLinks' + nodeId;

            if (data.links != null && data.links != '') {
                tableLinks.style.display = 'inline';
                var temp = '#TableLinksTemplate';
                $(tableLinks).html($.tmpl($(temp), data.links));
                $(object).find(".TableLinksContainer").show();
            }
            else {
                $(object).find(".TableLinksContainer").hide();
                $(tableLinks).hide().siblings('h4').hide();
            }

            butFavorite.id = 'butFavorite' + nodeId;
            butEdit.id = 'butEdit' + nodeId;
            butHide.id = 'butHide' + nodeId;
            butOpenDoc.id = 'butOpenDoc' + nodeId;
            butRefresh.id = 'butRefresh' + nodeId;
            butCollapse.id = 'butCollapse' + nodeId;

            if (data.videoLink != "") {
                var iVideo = object.getElementsByClassName('divDocumentVideo')[0];
                iVideo.innerHTML = data.videoLink;
            }


            objName.innerHTML = elementName;
            objDescription.innerHTML = elementDescription;

            var str = '';
            if (data.links != null) {
                for (i = 0; i < data.links.length; i++) {
                    str += data.links[i].link + "###";
                    str += data.links[i].name;
                    str += ';';
                }

            }

            multimdiaLinks = str;
            object.setAttribute('data-links', multimdiaLinks);

            doOpen(nodeId);
        };

        var lastNodeAction;

        function doCollapse(id) {
            var obj = $('#documentBody' + id);
            var but = $('#butCollapse' + id);
            if (obj.is(":visible")) {
                obj.hide();
                but.addClass('expand-custom');
                but.removeClass('collapse-custom');
            }
            else {
                obj.show();
                but.addClass('collapse-custom');
                but.removeClass('expand-custom');

            }
        }

        function doOpen(id) {
            var obj = $('#documentBody' + id);
            obj.show();
        }

        function doCollapseAll() {
            $('.divDocumentBody').hide();
        }

        function doFavorite(id) {
            lastNodeAction = id;
            id = id.replace('butFavorite', '');

            callAsyncActionOnServer('doFavorite', '{ nodeId: \'' + id + '\' }', false, showIsFavorite);
        }

        function doOpenDoc(id) {
            var obj = $('#document' + id);
            var documentLink = obj.attr('data-link');
            var documentType = obj.attr('data-document-type');
            var documentID = obj.attr('data-document-id');

            if (documentType == 1) {
                window.open(documentLink);
            } else {
                var successCallBack = function(response) {
                    if (response.d) {
                        window.location.assign(response.d);
                    } else {
                        bootbox.alert('The requested file is no longer available.')
                    }

                    Metronic.unblockUI();
                };
        
                Metronic.blockUI({ zIndex: 11000 }); //Adds z-index to position it over modal

                callActionOnServer('DownloadLinkedFile', JSON.stringify({ documentID: documentID }), successCallBack)
            }
        }

        function showIsFavorite(result) {
            if (result.d || result.d == false) {
                result = result.d;
            };

            if (result == true) {

                var node = $('#mainTree').jstree().get_node(lastNodeAction.replace('butFavorite', ''));

                if (node == false) {
                    node = $('#mainTree').jstree().get_node(lastNodeAction.replace('butFavorite', '').replace('F', 'D'));
                }

                var alreadyExists = $('#mainTree').jstree().get_node(lastNodeAction.replace('butFavorite', '').replace('D', 'F'));

                if (alreadyExists == false) {
                    var fav = $('#mainTree').jstree().get_node('cFav000');
                    var newNode = jQuery.extend({}, node); //This creates an exact copy of the 'node' object
                    newNode.id = node.id.replace('D', 'F');
                    $('#mainTree').jstree().copy_node(newNode, fav);
                    var fav = $('#mainTree').jstree().deselect_node(node);
                }

                $('#' + lastNodeAction).removeClass('heart');
                $('#' + lastNodeAction).addClass('heart-red');
            }
            else {
                var alreadyExists = $('#mainTree').jstree().get_node(lastNodeAction.replace('butFavorite', '').replace('D', 'F'));
                if (alreadyExists != false) {
                    $('#mainTree').jstree(true).delete_node(alreadyExists);
                }

                $('#' + lastNodeAction).removeClass('heart-red');
                $('#' + lastNodeAction).addClass('heart');

            }
        }

        $(document).ready(function () {
            DocumentPermissionsViewUsersGroup = $('#<%=DocumentPermissionsViewUsersGroup.ClientID%>');
            DocumentPermissionsEditUsersGroup = $('#<%=DocumentPermissionsEditUsersGroup.ClientID%>');

            $(document).on('click', '#SavePermissions', function () {
                var ID = $("#PermissionsModalNodeID").val();
                var type = $("#PermissionsModalNodeType").val();
                var viewers = DocumentPermissionsViewUsersGroup.find('.selected-users').val()
                var editors = DocumentPermissionsEditUsersGroup.find('.selected-users').val()

                if (type == 'c') {
                    setCategoryPermissions(ID, viewers, editors);
                } else if (type == 'd') {
                    setDocumentPermissions(ID, viewers, editors);
                }

                $("#permissions-modal").modal('hide');
            })

            if ($('#UserBoxStorageAccountID').val()) {
                $('#butOptionLinkExistingFile').show();
            } else {
                $('#butOptionLinkExistingFile').hide();
            }

            var options = {
                clientId: '<%=this.BoxAPPClientID%>',
                linkType: 'direct',
                multiselect: 'false'
            };

            var boxSelect = new BoxSelect(options);

            // Register a success callback handler
            boxSelect.success(function (response) {
                var data = {
                    fileID: response[0].id,
                    userStorageAccountID: $('#UserBoxStorageAccountID').val(),
                    provider: 1 //Box
                };


                var callbackSuccess = function (data) {
                    Metronic.unblockUI();

                    if (data.d) {
                        $('#LinkedFileID').val(response[0].id);
                        $('#LinkedFileName').val(response[0].name);
                        $('#LinkedFileNameLabel').text(response[0].name);
                    }
                    else {
                        $('#LinkedFileID').val('');
                        $('#LinkedFileName').val('');
                        $('#LinkedFileNameLabel').text('No file chosen');

                        bootbox.alert('The file is not accessible using your linked account. Please log out from Box website and re-login using the corresponding account in order to link existing files.');
                        return;
                    }
                }

                $('#LinkedFileNameLabel').text('Loading...');
                call(resolveHost() + '/ManageUpWebService.asmx/IsFileAvailable', JSON.stringify(data), callbackSuccess);
            });

            $(document).on('click', '.AddExistingFile', function () {
                $(this).tooltip('hide');
                $(this).blur();
                boxSelect.launchPopup();
            });
            

            //JStree configuration
            $('#mainTree').bind("dblclick.jstree", function (event) {
                var node = $(event.target).closest("li");
                $('#mainTree').jstree(true).toggle_node(node);
            });

        });


    </script>

    <style>
        .sharing-information-container {
            border-left: 1px solid lightgray;
        }
        .jstree-node .archived {
            background: #fcf8e3;
            color: #8a6d3b;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-content-wrapper">
        <div class="page-content">
            <h3 class="hide-on-content-only page-title">Playbook
                <%--<small>An Task that is personal to the owner, view and actionable only by task owner</small>--%>
            </h3>
            <div class="page-bar">
                <ul class="page-breadcrumb">
                    <li class="ms-hover">
                        <i class="fa fa-home"></i>
                        <a href="dashboardjsnew.aspx">Dashboard</a>
                        <i class="fa fa-angle-right"></i>
                    </li>
                    <li class="ms-hover">
                        <a href="#">Playbook</a>
                    </li>
                </ul>
            </div>

            <div id="general-error-container"></div>

            <div class="row playbook">
                <div class="col-md-4">
                    <div class="scroller" style="height: 600px">
                        <div class="portlet box">
                            <div class="portlet-title">
                                <div class="caption">
                                    PLAYBOOK
                                </div>

                                <div class="btn-group pull-right" id="playbook-sortby-handler">

                                    <div class="clearfix"></div>
                                    <ul class="dropdown-menu" role="menu">
                                        <li><a href="#">Type </a></li>
                                        <li><a href="#">Name </a></li>
                                    </ul>

                                </div>

                                <div class="gray-liner"></div>

                                <button id="create-category" onclick="newCategory();" type="button" class="btn green">+ Add Folder</button>

                                <button id="create-document" onclick="newDocument();" type="button" class="btn green">+ Add File</button>
                                <button id="create-video" style="display: none" type="button" class="btn grey-deactivated">+ Add Video</button>

                                <div class="gray-liner marT10"></div>
                                <div class="row">
                                    <div class="col-xs-11">
                                        <div class="input-icon top-padding">
                                            <i class="fa fa-search"></i>
                                            <input name="search" class="form-control" id="playbook-search" placeholder="Search" type="text" onkeydown="if (event.keyCode == 13) return false;" />
                                        </div>
                                    </div>
                                    <div class="col-xs-1" style="padding-left: 0px;">
                                        <a type="button" href="#" onclick="javascript: $('#playbook-search').val('').trigger('keyup');return false;"><i class="fa fa-remove margin-top-20"></i></a>
                                    </div>
                                </div>
                                <div class="gray-liner marT10"></div>

                                <div class="row marT10">
                                    <div class="col-xs-11">
                                        <label style="color: black;">
                                            <asp:CheckBox runat="server" ID="ShowArchivedCheck" Checked="false" Text="" OnCheckedChanged="ShowArchived_CheckedChanged" AutoPostBack="true" />
                                            Show Archived
                                        </label>
                                    </div>
                                </div>

                            </div>
                            <div class="portlet-body">
                                <div class="light-liner bottom-padding"></div>
                                <div id="mainTree"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div id='divSearch' class="col-md-8" style="display: none">
                    <div class="portlet box">
                        <table id="TableFind" class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div id="divDocumentContainer" class="col-md-8">
                    <!-- THIS IS WHERE YOU'RE GOING TO START DYNAMICALLY LOADING CONTENT -->
                    <div id='divCategoryToClone' style="display: none" data-description="" data-name="" data-document-type="" data-document-id="">
                        <div class="portlet box">

                            <!-- title -->
                            <div class="portlet-title">
                                <div class="caption divDocumentName">
                                    < NAME OF FILE >
                                </div>
                                <div class="tools">
                                    <a onclick="doCollapse(this.id.replace('butCollapse',''));" class="collapse-custom butCollapse"></a>
                                    <a onclick="refreshCategory(this.id.replace('butRefresh',''));" class="reload butRefresh"></a>
                                    <a onclick="hideCategory(this.id);" class="custom-remove butHide"></a>
                                </div>
                                <div class="gray-liner"></div>
                                <div style="height: 10px">&nbsp;</div>
                            </div>
                            <!-- end title -->

                            <!-- start -->
                            <div class="portlet-body divDocumentBody">
                                <div class="row">
                                    <div class="col-md-12">
                                        <h4>Sharing Information</h4>
                                        <hr />
                                        <div style="margin-left: 10px;">
                                            <div class="form-group">
                                                <p class="col-md-5 form-control-static"><i class="fa fa-user"></i><b> Owner</b></p>
                                                <div class="col-md-12">
                                                    <p class="form-control-static sharingInformationOwner"></p>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-5 form-control-static"><i class="fa fa-eye"></i><b> Viewers</b></label>
                                                <div class="col-md-12">
                                                    <p class="form-control-static sharingInformationViewers truncate-field" data-max-char='100'></p>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-5 form-control-static"><i class="fa fa-pencil"></i><b> Editors</b></label>
                                                <div class="col-md-12">
                                                    <p class="form-control-static sharingInformationEditors truncate-field" data-max-char='100'></p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                            <!-- end -->
                        </div>
                    </div>




                    <!-- START EXAMPLE DOCUMENT -->
                    <div id='divDocumentToClone' style="display: none" data-description="" data-name="" data-document-type="" data-document-id="">
                        <div class="portlet box">

                            <!-- title -->
                            <div class="portlet-title">
                                <div class="caption divDocumentName">
                                    < NAME OF FILE >
                                </div>
                                <div class="tools">
                                    <a onclick="doFavorite(this.id);" class="heart butFavorite"></a>
                                    <a onclick="doCollapse(this.id.replace('butCollapse',''));" class="collapse-custom butCollapse"></a>
                                    <a onclick="editNode(this.id.replace('butEdit',''));" class="edit butEdit"></a>
                                    <a onclick="refresh(this.id.replace('butRefresh',''));" class="reload butRefresh"></a>
                                    <a onclick="hideDocument(this.id);" class="custom-remove butHide"></a>
                                </div>
                                <div class="gray-liner"></div>
                                <div style="height: 10px">&nbsp;</div>
                            </div>
                            <!-- end title -->

                            <!-- start -->
                            <div class="portlet-body divDocumentBody">
                                <div class="row">
                                    <div class="col-md-8">
                                        <div class="divDocumentVideo">
                                        </div>


                                        <div class="subtitle" style="display: none">
                                            Subtitle Information
                                        </div>

                                        <div class="optional-subtitle" style="display: none">
                                            H3 information if needed
                                        </div>

                                        <h4>Description</h4>
                                        <p class="divDocumentDescription">
                                            At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique.
                                        </p>

                                    </div>

                                    <div class="col-md-4 sharing-information-container">
                                        <h4>Sharing Information</h4>
                                        <hr />
                                        <div>
                                            <div class="form-group">
                                                <p class="col-md-5 form-control-static"><i class="fa fa-user"></i><b> Owner</b></p>
                                                <div class="col-md-12">
                                                    <p class="form-control-static sharingInformationOwner"></p>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-5 form-control-static"><i class="fa fa-eye"></i><b> Viewers</b></label>
                                                <div class="col-md-12">
                                                    <p class="form-control-static sharingInformationViewers truncate-field" data-max-char='100'></p>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-5 form-control-static"><i class="fa fa-pencil"></i><b> Editors</b></label>
                                                <div class="col-md-12">
                                                    <p class="form-control-static sharingInformationEditors truncate-field" data-max-char='100'></p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row TableLinksContainer" style="display: none">
                                    <div class="col-md-12">
                                        <div id="multimediaSection">
                                            <hr />
                                            <h4>Multimedia Links</h4>
                                            <input type="hidden" class="labDocumentLink" /><input type="hidden" class="labDocumentId" />

                                            <div class="col-md-12 TableLinksClass">

                                            </div>

                                            <!-- ////////////////////// START TABLE ///////////////////////////////////////////// -->
                                            <table class="table table-striped table-hover" style="display: none">
                                                <thead>
                                                    <tr>
                                                        <th>Name </th>
                                                    </tr>
                                                </thead>
                                                <tbody>

                                                    <!-- ////// query loop start -->
                                                    <tr>
                                                        <td><a href="#">Donec ullamcorper nulla non metus auctor fringilla.</a> </td>
                                                    </tr>
                                                    <!-- ////// query loop end -->


                                                    <!-- ////// START DELETE HERE! FOR EXAMPLE ONLY -->
                                                    <tr>
                                                        <td><a href="#">Ullamcorper nulla non metus auctor fringilla.</a> </td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="#">Maecenas sed diam eget risus varius blandit sit amet non magna.</a> </td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="#">Faucibus mollis interdum.</a> </td>
                                                    </tr>

                                                    <!-- ////// END DELETE HERE! FOR EXAMPLE ONLY -->
                                                </tbody>

                                            </table>
                                            <!-- ////////////////////// END TABLE ///////////////////////////////////////////// -->
                                        </div>
                                    </div>
                                    
                                </div>
                                <hr />

                                <div class="row">
                                    <!-- button -->
                                    <div class="text-center">
                                        <a href="#" class="btn green butOpenDoc" onclick="doOpenDoc(this.id.replace('butOpenDoc',''));">Open</a>
                                    </div>
                                    <!-- end button -->
                                </div>

                            </div>
                            <!-- end -->
                        </div>
                    </div>
                    <!-- end portlet box -->
                    <!-- END EXAMPLE DOCUMENT -->

                    <!-- START EXAMPLE MULTIMEDIA DOCUMENT -->
                    <!-- start -->
                    <div class="portlet box" style="display: none">

                        <!-- title -->
                        <div class="portlet-title">
                            <div class="caption">
                                < NAME OF MULTIMEDIA FILE >
                            </div>
                            <div class="tools">
                                <a href="javascript:;" class="heart"></a>
                                <a href="javascript:;" class="collapse"></a>
                                <a href="javascript:;" class="edit"></a>
                                <a href="javascript:;" class="reload"></a>
                                <a href="javascript:;" class="remove"></a>
                            </div>

                            <div class="gray-liner"></div>
                        </div>
                        <!-- end title -->

                        <!-- start -->
                        <div class="portlet-body">


                            <p>
                                At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique.
                            </p>

                            <p>
                                At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique.
                            </p>

                            <div class="breaker"></div>
                            <a href="#" class="show-more">&raquo; Show more (expand)</a>


                            <h4 class="multimedia">Multimedia Links</h4>


                            <!-- ////////////////////// START TABLE 2 ///////////////////////////////////////////// -->
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Name </th>
                                    </tr>
                                </thead>
                                <tbody>

                                    <!-- ////// query loop start -->
                                    <tr>
                                        <td><a href="#">Donec ullamcorper nulla non metus auctor fringilla.</a> </td>
                                    </tr>
                                    <!-- ////// query loop end -->


                                    <!-- ////// START DELETE HERE! FOR EXAMPLE ONLY -->
                                    <tr>
                                        <td><a href="#">Ullamcorper nulla non metus auctor fringilla.</a> </td>
                                    </tr>
                                    <tr>
                                        <td><a href="#">Maecenas sed diam eget risus varius blandit sit amet non magna.</a> </td>
                                    </tr>
                                    <tr>
                                        <td><a href="#">Faucibus mollis interdum.</a> </td>
                                    </tr>

                                    <!-- ////// END DELETE HERE! FOR EXAMPLE ONLY -->
                                </tbody>

                            </table>
                            <!-- ////////////////////// END TABLE 2 ///////////////////////////////////////////// -->

                            <!-- button -->
                            <div class="text-center">
                                <a href="#" class="btn green">Watch Video </a>
                            </div>
                            <!-- end button -->

                        </div>
                        <!-- end -->

                    </div>
                </div>

            </div>
            <input type="hidden" runat="server" id="mainTreeSelectedId" />
            <input style="display: none" type="text" runat="server" id="txtId" />
        </div>
    </div>

    <div id="document-modal" class="modal fade bs-modal-lg" tabindex="-1" aria-hidden="true" data-heightmargin="80">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>New File</h2>
                </div>
                <div class="modal-body form">
                    <div class="form-horizontal">
                        <div class="form-body label-large" role="form">
                            <div id="document-modal-errors">

                            </div>

                            <div id="edition-instructions" class="note note-info" style="display: none;">
                                <h3>Edition Instructions</h3>
                                <h5>In order to edit a playbook item, the following steps are required:</h5>
                                <h5>1. Download the attached file to your computer using the <b>Open</b> button and modify it</h5>
                                <h5>2. Edit the playbook item with the edition button (<i class="fa fa-pencil"></i>)</h5>
                                <h5>3. Upload the new version of the file and save the changes</h5>
                            </div>

                            <h4>File Information</h4>
                            <br />
                            <div class="alert alert-error" style="display: none;">
                            </div>

                            <div class="form-group">
                                <label class="control-label col-md-2" for="fname">Name</label>
                                <div class="col-md-10">
                                    <asp:TextBox runat="server" ID="txtDocumentName" class="form-control" />
                                    <label class="help-inline" id="username-error" style="display: none">The 'User Name' is duplicated</label>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="control-label col-md-2" for="fname">Description</label>
                                <div class="col-md-10">
                                    <asp:TextBox runat="server" ID="txtDocumentDescription" TextMode="MultiLine" class="form-control" />
                                </div>
                            </div>


                            <div class="form-group">
                                <label class="control-label col-md-2" for="fname">Type</label>
                                <div class="col-md-9">
                                    <div class="btn-group ui-button ui-widget ui-state-default ui-corner-all 
                                        ui-button-text-only"
                                        data-toggle="buttons-checkbox"
                                        role="button" aria-disabled="false">
                                        <span>
                                            <button id="butOptionFile" type="button" class="btn blue" onclick="selectFileOption();">Upload File</button>
                                            <button id="butOptionLinkExistingFile" type="button" class="btn blue" onclick="selectLinkExistingFileOption();">Link Existing File</button>
                                            <button id="butOptionLink" type="button" class="btn blue" onclick="selectLinkOption();">Add Link</button>
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <div id="divFile" class="form-group">
                                <label class="control-label col-md-2" for="fname"></label>
                                <div class="col-md-10">
                                    <asp:FileUpload ID="FileUpload1" runat="server" class="input-large reset-input" />
                                </div>
                            </div>

                            <div id="divLinkExistingFile" class="form-group">
                                <asp:HiddenField ID="UserBoxStorageAccountID" runat="server" />
                                <label class="control-label col-md-2" for="fname"></label>
                                <div class="col-md-10">
                                    <button class="AddExistingFile withTooltip" data-title="Link an existing file from one of your linked applications" type="button" runat="server">Link Existing File</button>
                                    <label id="LinkedFileNameLabel">No file chosen...</label>
                                    <asp:HiddenField ID="LinkedFileID" runat="server" />
                                    <asp:HiddenField ID="LinkedFileName" runat="server" />
                                </div>
                            </div>

                            <div id="divLink" class="form-group">
                                <label class="control-label col-md-2" for="fname"></label>
                                <div class="col-md-10">
                                    <asp:TextBox runat="server" ID="txtDocumentLink" class="input-large reset-input form-control" placeholder="http://www.yoururl.com" />
                                    <input id="butViewLink" style="display: none" type="button" value="View" class="btn create-btn btn-success" onclick="window.open(documentLink);" />
                                </div>
                            </div>
                            
                            <h4>Multimedia Links</h4>
                            
                            <div class="row">
                                <div class="col-md-offset-1 col-md-4">
                                    <input type="button" id="addLink" class="btn green" value="+ Multimedia Link" onclick="addDocumentLink('');" />
                                </div>
                            </div>
                            <asp:TextBox runat="server" ID="txtExtraLinks" Style="display: none" />

                            <br />
                            <div class="row">
                                <div class="col-md-offset-1 col-md-11" id="divLinks">
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <input type="button" id="buttonSaveDocument" runat="server" class="btn green" value="Save" onclick="validateNewDocument();" />
                    <asp:Button CssClass="btn btn-warning" Style="display: none" ID="butAddDocument" runat="server" Text="Save" OnClick="butAddDocument_Click" />
                    <input type="button" data-dismiss="modal" class="btn red" value="Cancel" onclick="" />
                </div>
            </div>
        </div>
    </div>


    <div id="category-modal" class="modal fade" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">

                <div class="modal-header">
                    <h2>New Folder</h2>
                </div>
                <div class="modal-body">
                    <div class="form-horizontal fuelux no-left-margin label-large" role="form">
                        <div id="category-modal-errors">

                        </div>
                        <div class="alert alert-error" style="display: none;">
                        </div>

                        <div class="control-group">
                            <label class="control-label" for="fname">Folder Name</label>
                            <div class="controls">
                                <asp:TextBox runat="server" ID="txtCategoryName" class="form-control" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="fname">Folder Description</label>
                            <div class="controls">
                                <asp:TextBox runat="server" ID="txtCategoryDescription" TextMode="MultiLine" class="form-control" />
                            </div>
                        </div>

                    </div>
                </div>
                <div class="modal-footer">
                    <input type="button" id="buttonSaveCategory" runat="server" class="btn green" value="Save" onclick="validateNewCategory();" />
                    <asp:Button ID="butSaveCategory" runat="server" Style="display: none" Text="Save" OnClick="butAdd_Click" />
                    <input type="button" data-dismiss="modal" class="btn red" value="Cancel" onclick="" />
                </div>
            </div>
        </div>
    </div>

    <div id="CreateConfirmation" class="modal fade" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">

                <div class="modal-header">
                    <h2>Archive confirmation</h2>
                </div>
                <div class="modal-body">
                    <h3 id="TaskCreateStatus"></h3>
                </div>
                <div class="modal-footer">
                    <a href="#" class="btn btn-success" onclick="confirmDelete();">Ok</a>
                    <a href="#" class="btn btn-success" onclick="cancelDelete();">Cancel</a>
                </div>
            </div>
        </div>
    </div>

    <script id="TableFindTemplate" class="labTableTemplate" type="text/x-jquery-tmpl">
        <tr>
            <td><a target="_blank" href="${link}">${name}</a></td>
        </tr>
    </script>


    <script id="TableLinksTemplate" class="labTableTemplate" type="text/x-jquery-tmpl">
        <div class="row">
            <div class="form-group" style="margin-bottom: 0px;">
                <label class="control-label col-md-1"><i class="fa fa-link"></i></label>
                <div class="col-md-10">
                    <a class="form-control-static" target="_blank" href="${link}">${name}</a>
                </div>
            </div>
        </div>
    </script>
    
    <div id="permissions-modal" class="modal bs-modal-lg fade" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Permissions</h2>
                </div>
                <div class="modal-body">
                    <div class="col-md-12">
                        <div class="note note-info">
                            <h5>When granted <b>Edit</b> permissions, a user is able to edit all the information from a playbook item, allowing him to download the attached file, modify it and upload the new version into the same playbook item.</h5>
                        </div>
                    </div>
                    <input type="hidden" id="PermissionsModalNodeID" />
                    <input type="hidden" id="PermissionsModalNodeType" />
                    <div class="row">
                        <div class="col-md-12">
                            <label class="control-label col-md-2">View</label>
                            <div class="col-md-9">
                                <uc:UsersGroup runat="server" ID="DocumentPermissionsViewUsersGroup" ButtonConfirmName="Save" ClientIDMode="AutoId"></uc:UsersGroup>
                            </div>
                        </div>
                    </div>
                    <div class="row margin-top-15">
                        <div class="col-md-12">
                            <label class="control-label col-md-2">Edit</label>
                            <div class="col-md-9">
                                <uc:UsersGroup runat="server" ID="DocumentPermissionsEditUsersGroup" ButtonConfirmName="Save" ClientIDMode="AutoId"></uc:UsersGroup>
                            </div>
                        </div>
                    </div>
                    <div id="override-permissions-container" class="row margin-top-15">
                        <div class="col-md-12">
                            <div class="col-md-offset-2 col-md-9">
                                <label><input type="checkbox" id="override-permissions-checkbox"/> Override permissions on every sub folder and file within this folder </label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <input type="button" id="SavePermissions" class="btn green" value="Save" />
                    <input type="button" data-dismiss="modal" class="btn red" value="Cancel" onclick="" />
                </div>
            </div>
        </div>
    </div>

    <uc:UsersGroupModal runat="server" ID="UsersGroupModal" ClientIDMode="AutoId"></uc:UsersGroupModal>
</asp:Content>

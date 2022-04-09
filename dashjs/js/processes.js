var aspxPage = 'processes.aspx';

var movingNode;
var parentNode;

var deletingNode;
var deleteConfirmed = false;

var elementModifyId;
var elementType = '';
var elementName = '';
var elementDescription = '';

var categoryId;

var role = 0;
var writePermission = false;

function loadEverything(r, write) {
    role = r;
    writePermission = write;
    showActions(' ');
    $('.btn-group').button();

    var to = false;
    $('#playbook-search').keyup(function () {
        if (to) { clearTimeout(to); };
        to = setTimeout(function () {
            var v = $('#playbook-search').val();
            $('#mainTree').jstree().search(v);
        }, 250);
    });

    // initiate layout and plugins
    UITree.init(); // ui tree init
}

function readyJstree() {
    //If a node was selected after postback we select it again when reloading the page
    var currentSelectedNodeID = $("#mainTreeSelectedId").val();
    if (currentSelectedNodeID) {
        openAndSelectNodeOnTree(currentSelectedNodeID);
    } else {
        //Open document passed by query string
        if (queryStringPlaybookDocumentID) {
            var nodeID = 'D' + queryStringPlaybookDocumentID;
            var node = $("#mainTree").jstree(true).get_node(nodeID);
            if (node) {
                //Open tree and select node
                openAndSelectNodeOnTree(nodeID);

                //Open file container
                $('#divDocument').show();
                loadDocument(nodeID, false);
            } else {
                bootbox.alert("The specified file does not exist or you don't have enough permissions to view it, please contact the owner of the file");
            }
        }
    }
};

function openAndSelectNodeOnTree(nodeID) {
    //Open and select node
    $('#mainTree').jstree(true)._open_to(nodeID);
    $('#mainTree').jstree(true).open_node(nodeID);
    $('#mainTree').jstree(true).select_node(nodeID);

    //Scroll the tree to the node position
    var nodePosition = $('#' + nodeID).position();
    if (nodePosition) {
        var scrollTo = nodePosition.top;
        $('#mainTree').closest(".scroller").slimScroll({ scrollTo: scrollTo });
    }
}

function openedNode(event, data) {
    var openedNodes = getOpenedNodes();
    openedNodes.push(data.node.id);

    setOpenedNodes(openedNodes);
};

function closedNode(event, data) {
    var openedNodes = getOpenedNodes();
    openedNodes = removeFromArrayWithCondition(openedNodes, function (el) { return el == data.node.id; });

    setOpenedNodes(openedNodes);
};

function getOpenedNodes() {
    var openedNodes = $.cookie('opened-nodes');

    try {
        openedNodes = JSON.parse(openedNodes);
    }
    catch (e) {
        openedNodes = [];
    };

    return openedNodes;
};

function setOpenedNodes(openedNodes) {
    $.cookie('opened-nodes', JSON.stringify(openedNodes));
};

//shows the modal for createing a new category.
function newCategory() {

    document.getElementById('txtId').value = '';
    document.getElementById('txtCategoryName').value = '';
    document.getElementById('txtCategoryDescription').value = '';

    $('#category-modal').modal('show');
}

//shows the modal for creating a new document.
function newDocument() {
    clearLinks();
    document.getElementById('butOptionFile').click();

    document.getElementById('txtDocumentName').value = '';
    $('#txtDocumentDescription').summernote('code', '');
    document.getElementById('txtDocumentLink').value = '';

    document.getElementById('butViewLink').style.display = 'none';
    document.getElementById('txtId').value = '';
    $('#document-modal').modal('show');
    $('#edition-instructions').hide();
}

function loadDatatable() {
    $('#GridView1').dataTable();
}

function selectFileOption() {
    $("#butOptionFile").addClass("active");

    document.getElementById('divFile').style.display = 'inline';
    document.getElementById('divLinkExistingFile').style.display = 'none';
    document.getElementById('divLink').style.display = 'none';

    resetLinkExistingFileFields();
    resetLinkFields();
}

function selectLinkExistingFileOption() {
    $("#butOptionLinkExistingFile").addClass("active");

    document.getElementById('divFile').style.display = 'none';
    document.getElementById('divLinkExistingFile').style.display = 'inline';
    document.getElementById('divLink').style.display = 'none';

    resetFileFields();
    resetLinkFields();
}

function selectLinkOption() {
    $("#butOptionLink").addClass("active");

    document.getElementById('divFile').style.display = 'none';
    document.getElementById('divLinkExistingFile').style.display = 'none';
    document.getElementById('divLink').style.display = 'inline';

    resetLinkExistingFileFields();
    resetFileFields();
}

function resetLinkExistingFileFields() {
    $("#butOptionLinkExistingFile").removeClass("active");

    $('#LinkedFileID').val('');
    $('#LinkedFileName').val('');
    $('#LinkedFileNameLabel').text('No file chosen');
}

function resetFileFields() {
    $("#butOptionFile").removeClass("active");
    $('#FileUpload1').replaceWith($('#FileUpload1').clone());
}

function resetLinkFields() {
    $("#butOptionLink").removeClass("active");
    $('#txtDocumentLink').val("");
}

//Called when the user edits a node (document or category) for modifying it. 
function addTooltip(e, data) {
    var id = data.node.id;


    var n = $('#mainTree').jstree().get_node(id);
    var json = $('#mainTree').jstree().get_json(n);
    var fullText = json.data;

    $('#' + data.node.id).prop('title', fullText);
}

function editNode(id) {
    var obj = $('#document' + id);

    elementModifyId = id.replace('D', '').replace('F', '');
    elementType = 'D';
    elementName = obj.attr('data-name');
    elementDescription = obj.attr('data-description');
    multimdiaLinks = obj.attr('data-links');

    documentLink = obj.attr('data-link');

    var container = document.getElementById('divLinks');
    container.innerHTML = '';
    document.getElementById('txtId').value = elementModifyId;

    if (elementType == 'D') {
        $('#edition-instructions').show();
        var vecMultimediaLinks = multimdiaLinks.split(';');
        var i;
        for (i = 0; i < vecMultimediaLinks.length; i++) {
            var d = vecMultimediaLinks[i].split('###');

            var link = d[0];
            var name = d[1];

            if (link != '') {
                addDocumentLink(link, name);
            }
        }

        ctrlNumber = vecMultimediaLinks.length;

        document.getElementById('txtDocumentName').value = elementName;
        $('#txtDocumentDescription').summernote('code', elementDescription);
        document.getElementById('txtDocumentLink').value = documentLink;
        document.getElementById('butViewLink').style.display = 'inline';

        document.getElementById('butOptionLink').click();
        $('#document-modal').modal('show');
    }
    else {
        document.getElementById('txtCategoryName').value = elementName;
        document.getElementById('txtCategoryDescription').value = elementDescription;

        $('#category-modal').modal('show');
    }
}

//call it to change from one folder to another one in the main tree.
function viewFolder(node) {
    $('#mainTree').jstree().deselect_all();
    var n = $('#mainTree').jstree().get_node(node);
    $('#mainTree').jstree().select_node(n);
}

function customMenu(node, tr) {
    var nodeType = getTypeFromNode(node);
    var tree = $("#mainTree").jstree();
    var disableMenu = nodeType == 'f' || node.id == "cRootNode" || (node.original.attr.class == "disableMenu" && (role < 3));
    var disableArchive = !nodeCanBeArchived(node) || disableMenu;
    tree.deselect_all();
    tree.select_node(node.id);

    // The default set of all items
    var items = {
        permissionsItem: { // The "Permissions" menu item
            label: "Permissions",
            action: function (obj) { launchPermissionsModal(node); },
            _disabled: disableMenu
        },
        renameItem: { // The "rename" menu item
            label: "Rename",
            action: function (obj) { tr.edit(node); },
            _disabled: disableMenu
        },
        deleteItem: { // The "Archive/Unarchive" menu item
            label: isArchived(node) ? "Unarchive" : "Archive",
            action: function (obj) {
                //$('#mainTree').jstree(true).delete_node(node);
                archiveOrUnarchiveNode(node, !isArchived(node));
            },
            _disabled: disableArchive
        },
        viewInformationItem: { // The "View Information" menu item
            label: "View Information",
            action: function (obj) { openFolderContainer(node); },
            _disabled: nodeType != 'c' || node.id == "cRootNode"
            //_disabled: node.original.data_type != 'Folder' && node.original.data_type != 'Document' 
        }
    };

    if (nodeType != 'c' || node.id == "cRootNode") {
        delete items.viewInformationItem;
    }

    return items;
}

function nodeCanBeArchived(node) {
    //Remove main node from the parents list
    var parents = node.parents.slice(0, -1);

    //Check if any of the parents is archived
    return !parents.some(function (parentNodeID) {
        var parentNode = $("#mainTree").jstree(true).get_node(parentNodeID);
        return isArchived(parentNode);
    });
}


//functions related to multimedia links. Use these functions to create and delete dinamically multimedia links on the document modal page.
//ctrlNumber refers to the number of multimedia links we have created.

var ctrlNumber = 1;
function deleteLink(linkId) {
    $('#divMultimediaLink' + linkId).slideUp(300, function () {
        this.remove();
    });
}

function clearLinks() {
    var ctrl = document.getElementById('ctrlLink1')

    var cont = 1;
    while (ctrl != null) {
        deleteLink(cont);
        cont = cont + 1;

        ctrl = document.getElementById('ctrlLink' + cont.toString());
    }

}

function openFolderContainer(node) {
    $('#divDocument').show();
    categoryId = node.id.toString();
    loadCategory(categoryId, false)
}

function addDocumentLink(link, name) {
    var container = document.getElementById('divLinks');

    if (!name)
        name = "";

    var rawHtml = "\
        <div class='row divMultimediaLink' id='divMultimediaLink" + ctrlNumber + "'> \
            <div class='form-group'> \
                <label class='control-label col-md-1'><i class='fa fa-link'></i></label> \
                <div> \
	                <div class='controls col-md-4'> \
		                <input type='text' class='form-control multimediaLinkName' placeholder='Enter a name' value='" + name + "'>\
	                </div> \
	                <div class='controls col-md-4'> \
                        <input type='text' placeholder='http://www.yoururl.com' class='col-md-4 col-md-offset-1 form-control multimediaLinkURL' value='" + link + "'> \
	                </div> \
		            <img src='js/img/delete_icon.png' width='16' class='col-md-offset-1' onclick='deleteLink(" + ctrlNumber + ");' style='cursor: pointer; padding-top:8px;'> \
	            </div> \
            </div>\
        </div>"

    var row = $.parseHTML(rawHtml);

    container.appendChild(row[1]);
    ctrlNumber++;
}


//this functions is executed when the user changes the selected node on the main tree.
function loadDocument(idToLoad, refresh) {
    elementModifyId = idToLoad;
    loadContentTab(idToLoad, refresh);
    truncateFields();
}

function loadCategory(idToLoad, refresh) {
    loadCategoryContentTab(idToLoad, refresh);
    truncateFields();
}

function hideDocument(id) {
    id = id.replace('butHide', '');
    $('#document' + id).hide();

}

function hideCategory(id) {
    id = id.replace('butHide', '');
    $('#category' + id).hide();

}

function refresh(id) {
    id = id.replace('D', '').replace('F', '');
    loadDocument('D' + id, true);
}

function refreshCategory(id) {
    loadCategory(id, true);
}

function selectNodemainTree(e, data) {
    if (data.selected != '') {
        if (!isCategoryNode(data.selected.toString())) {
            if (data.node.id != 'cFav000') {
                $('#divDocument').show();
                loadDocument(data.selected.toString(), false);
            }
        }
        else {
            if (data.node.data != "Favorite" && data.node.id != "cRootNode") {
                //Here used to be opening folder when clicked
            } else {
                $('#divDocument').hide();
            }
        }

        var nodInfo = $("#" + data.selected);
        var parent_id_value = nodInfo.li_attr;

        document.getElementById('mainTreeSelectedId').value = data.selected;
    }
    else {
        $('#panelInfo').hide();
    };

    showActions(data);
}

//call it to open the 'loading' modal
function processLoading() {
    $('#loading-modal').modal('show');
}

//call it to close the 'loading' modal
function endProcessLoading() {
    $('#loading-modal').modal('hide');
}

//this function gets the box document refered to a node by using ajax.
function selectNodematchedDocuments(e, data) {
    var doc = callActionOnServer('getBoxDocumentById', '{nodeId: "' + data.selected + '" }', function (res) {
        var result = res.d;
        if (result != null) {
            window.open(result);
        };
    });
}


//called when the user selects a node on the subtree (find documents tree).
function selectNodesubtreecontents(e, data) {

    if (!isCategoryNode(data.selected.toString())) {
        callActionOnServer('getBoxDocumentById', '{nodeId: "' + data.selected + '" }', function (res) {
            var result = res.d;
            if (result != null) {
                window.open(result);
            };
        });
    }
    else {
        $('#mainTree').jstree().deselect_all();
        $('#mainTree').jstree().select_node(data.selected);
    }
}

//used by the maintree to validate if the user can execute some actions or not.
function validateActionOnTree(operation, node, node_parent, node_position, more) {

    var res = false;
    var conf = false;

    if (operation == 'rename_node') {
        return true;
    }

    if (operation == 'create_node') {
        return isCategoryNode(node_parent.id);
    }

    if (operation == 'move_node') {
        //Both DND plugin and CORE can call this function, so we check if there is a ref variable in the event data
        if (more.ref)
        {
            if (more.ref.id == 'cFav000' || more.ref.parent == 'cFav000' || more.ref.id == node.parent || (getTypeFromNode(node) == "d" && more.ref.id == "cRootNode")) {
                return false;
            }
        }

        movingNode = node.id;
        parentNode = node_parent.id;

        if (getTypeFromNode(node) == "d" && parentNode == "cRootNode") {
            return false;
        }

        return isCategoryNode(parentNode);
    }

    if (operation == 'delete_node') {
        if (node == null) {
            return false;
        };
    };

    if (res != '') {
        console.log(res);
        return false;
    }
    else {
        return true;
    };
}

function archiveOrUnarchiveNode(node, archive) {
    if (node == null)
        return;

    bootbox.confirm("You are going to " + (archive ? "archive" : "unarchive") + " this node and all of its contents. Are you sure you want to proceed?", function (result) {
        if (result) {
            callActionOnServer('archiveOrUnarchiveNode', JSON.stringify({ nodeId: node.id, archive: archive }), function (response) {
                var response = response.d
                if (response != '') {
                    bootbox.alert(response);
                }
                else {
                    showArchived = $("#ShowArchivedCheck").prop("checked");
                    setArchivedStyleOnBranch(node.id, archive, showArchived);
                }
            });
        }
    });
}

function setArchivedStyleOnBranch(nodeID, archive, showArchived) {
    var node = $("#mainTree").jstree(true).get_node(nodeID);

    //Add archive style to favorite if it exists
    setArchivedStyleOnFavorite(nodeID, archive, showArchived);

    var children = jQuery.extend({}, node.children); //We create a copy of the children because when we remove them the index changes breaking the following each loop

    //Add archived style to every children
    $.each(children, function (index, childID) {
        setArchivedStyleOnBranch(childID, archive, showArchived);
    });

    //Delete node or set archived styles
    if (showArchived) {
        node.original.a_attr = archive ? { "class": "archived" } : {};

        //Set archive style to node
        if (archive) {
            $("#" + nodeID).find("a").first().addClass("archived");
        } else {
            $("#" + nodeID).find("a").first().removeClass("archived");
        }
    } else {
        $('#mainTree').jstree(true).delete_node(node.id);
    }
}

//This function finds the favorite node related to the specified nodeID and if it exists applies the archived class to it
function setArchivedStyleOnFavorite(nodeID, archive, showArchived) {
    //Only files can be favorites
    if (getTypeFromNodeID(nodeID) != 'd') {
        return;
    }

    var favoriteID = nodeID.replace('D', 'F');
    var favoriteNode = $("#mainTree").jstree(true).get_node(favoriteID);
    if (favoriteNode) {
        if (showArchived) {
            if (archive) {
                $("#" + favoriteID).find("a").first().addClass("archived");
            } else {
                $("#" + favoriteID).find("a").first().removeClass("archived");
            }
        } else {
            $('#mainTree').jstree(true).delete_node(favoriteID);
        }
    }
}

//used by the maintree to move a node to another parent.
function moveNode(node, parent, position, old_parent, old_position, is_multi, old_instance, new_instance) {
    bootbox.alert('The item permissions are not going to be changed.')
    callActionOnServer('moveNode', '{ nodeId: "' + movingNode + '", parentId: "' + parentNode + '" }');
}

var nodeCreatedPreviously = false;
function createNode(obj, node, pos, callback, is_loaded) {
    nodeCreatedPreviously = true;
}

function callAsyncActionOnServer(action, params, showLoading, fSuccess) {
    callActionOnServer(action, params, fSuccess);
}

function callActionOnServer(action, params, fSuccess) {
    console.log('--------------------------');
    console.log(action);
    console.log(params);

    call(aspxPage + "/" + action, params, fSuccess);
}

function showActions(data) {
    var nodeId = data.selected ? data.selected : " ";
    var nId = nodeId.toString();

    var enableFolderCreation = false;
    var enableDocumentCreation = false;

    if ((role >= 3) || (writePermission == true))
        enableFolderCreation = true;

    if (isCategoryNode(nId) && ((role >= 3) || (writePermission == true))) {
        enableDocumentCreation = true;
    }

    var disableMenu = false;

    if (data.node) {
        if (isCategoryNode(nId)) {
            disableMenu = data.node.original.attr.class == "disableMenu";
        } else {
            parentNode = $('#mainTree').jstree(true).get_node(data.node.parent);
            disableMenu = parentNode.original.attr.class == "disableMenu";
        }
    }

    if (nodeId == 'cFav000' || getTypeFromNodeID(nId) == 'f' || disableMenu || isArchived(data.node)) {
        enableFolderCreation = false;
        enableDocumentCreation = false;
    }

    if (nodeId == 'cRootNode') {
        enableDocumentCreation = false;
    }

    $("#create-document").prop("disabled", !enableDocumentCreation);
    $("#create-category").prop("disabled", !enableFolderCreation);
}

function afterSearch() {
    endProcessLoading();

}

function validateNewCategory() {
    var container = $('#category-modal-errors');
    container.html("");

    var txtName = document.getElementById('txtCategoryName');

    var vecErrors = [];

    if (txtName.value == '') vecErrors.push('Folder Name is mandatory');

    if (vecErrors.length > 0) {
        showErrorMsgs(container, vecErrors);
    }
    else {
        document.getElementById('butSaveCategory').click();
    }

    return false;
}

function getDocumentLinks() {
    var multimediaLinkDivs = $(".divMultimediaLink");

    var links = '';

    multimediaLinkDivs.each(function (index) {
        var name = $(this).find('.multimediaLinkName').val();
        var url = $(this).find('.multimediaLinkURL').val();
        links += url + '###' + name + ';';
    });

    return links;
}

function validateNewDocument() {
    var container = $('#document-modal-errors');
    container.html("");

    document.getElementById('txtExtraLinks').value = getDocumentLinks();
    var txtName = document.getElementById('txtDocumentName');
    var file = document.getElementById('FileUpload1').value;
    var linkedFile = $('#LinkedFileID').val();
    var link = document.getElementById('txtDocumentLink').value;

    var vecErrors = [];

    if (txtName.value == '') vecErrors.push('File Name is mandatory');
    if (!file && !link && !linkedFile) vecErrors.push('You must insert a File or a Link');

    validateMultimediaLinks(vecErrors);

    if (link) {
        if (!link.startsWith("http")) {
            link = 'http://' + link;
            $("#txtDocumentLink").val(link);
        };

        if (!isValidUrl(link)) {
            vecErrors.push("The specified link is not a valid URL");
        }
    }

    if (vecErrors.length > 0) {
        showErrorMsgs(container, vecErrors);
    }
    else {
        document.getElementById('butAddDocument').click();
    }

    return false;
}

function isValidUrl(url) {
    var urlPattern = /\(?(?:(http|https|ftp):\/\/)?(?:((?:[^\W\s]|\.|-|[:]{1})+)@{1})?((?:www.)?(?:[^\W\s]|\.|-)+[\.][^\W\s]{2,4}|localhost(?=\/)|\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})(?::(\d*))?([\/]?[^\s\?]*[\/]{1})*(?:\/?([^\s\n\?\[\]\{\}\#]*(?:(?=\.)){1}|[^\s\n\?\[\]\{\}\.\#]*)?([\.]{1}[^\s\?\#]*)?)?(?:\?{1}([^\s\n\#\[\]]*))?([\#][^\s\n]*)?\)?/g;

    if (url.match(urlPattern)) {
        return true;
    } else {
        return false;
    }
}

function validateMultimediaLinks(vecErrors) {
    var multimediaLinkDivs = $(".divMultimediaLink");

    multimediaLinkDivs.each(function (index) {
        var name = $(this).find('.multimediaLinkName').val();
        var url = $(this).find('.multimediaLinkURL').val();

        if (!name) {
            vecErrors.push("A name must be specified for the multimedia link");
        }

        if (!isValidUrl(url)) {
            vecErrors.push("The multimedia link '" + name + "' is not a valid URL");
        }
    });

}

function renameNode(obj, val) {
    if (getTypeFromNodeID(val.node.id) == 'f') {
        return;
    }

    if (nodeCreatedPreviously) {
        callActionOnServer('createNode', '{categoryId: null, parentId: "' + val.node.parent + '", text: "' + val.text + '", description: "" }', function (result) {
            var res = result.d;
            if (res.Success) {
                var id = res.Data;
                $('#mainTree').jstree().set_id(val.node, 'C' + id);
            }
        });
    }
    else {
        callActionOnServer('renameNode', '{nodeId: "' + val.node.id + '", text: "' + val.text + '" }', function (response) {
            var error = response.d;
            if (error) {
                showErrorMsgs($("#general-error-container"), [error]);
                $('#mainTree').jstree().rename_node(val.node, val.old);
            } else {
                renameFavoriteNode(val.node, val.text);
            }
        });
    }

    nodeCreatedPreviously = false;

}

function renameFavoriteNode(node, newName) {
    //Only files can be favorites
    if (getTypeFromNodeID(node.id) != 'd') {
        return;
    }

    var favoriteID = node.id.replace('D', 'F');
    var favoriteNode = $("#mainTree").jstree(true).get_node(favoriteID);
    if (favoriteNode) {
        $('#mainTree').jstree().rename_node(favoriteNode, newName);
    }
}

function isCategoryNode(nodeId) {
    return (nodeId.charAt(0) == 'c') || (nodeId.charAt(0) == 'C');
}

function launchPermissionsModal(node) {
    var type = getTypeFromNode(node);
    var ID = getIDFromNode(node);

    $("#PermissionsModalNodeID").val(ID);
    $("#PermissionsModalNodeType").val(type);

    if (type == 'c') { //Category
        $('#override-permissions-container').show();
        $('#override-permissions-checkbox').prop('checked', false);
        $('#override-permissions-checkbox').parent().removeClass('checked');

        getCategoryPermissions(ID);

    } else if (type == 'd') {  //Document
        $('#override-permissions-container').hide();
        getDocumentPermissions(ID);
    }

    $('#permissions-modal').modal('show');
}

function getIDFromNode(node) {
    var nodeID = node.id;

    return getIDFromNodeID(nodeID);
}

function getIDFromNodeID(nodeID) {
    return nodeID.toLowerCase().replace('c', '').replace('d', '').replace('f', '');
}

function getTypeFromNode(node) {

    if (node.data == 'Favorite') {
        return 'f';
    }

    return getTypeFromNodeID(node.id);
}

function getTypeFromNodeID(nodeID) {
    var nodeID = nodeID.toLowerCase();
    return nodeID.charAt(0);
}

function getDocumentPermissions(documentID) {
    Metronic.blockUI();

    callActionOnServer('GetDocumentPermissions', JSON.stringify({ documentID: documentID }), function (response) {
        var permissions = response.d;

        if (permissions) {
            DocumentPermissionsViewUsersGroup.find('.selected-users').val(permissions.Viewers).trigger('change');
            DocumentPermissionsEditUsersGroup.find('.selected-users').val(permissions.Editors).trigger('change');
        } else {
            bootbox.alert("The specified file does not exist or you don't have enough permissions to view it.");
        }

        Metronic.unblockUI();
    });
}

function getCategoryPermissions(categoryID) {
    Metronic.blockUI();

    callActionOnServer('GetCategoryPermissions', JSON.stringify({ categoryID: categoryID }), function (response) {
        var permissions = response.d;

        DocumentPermissionsViewUsersGroup.find('.selected-users').val(permissions.Viewers).trigger('change');
        DocumentPermissionsEditUsersGroup.find('.selected-users').val(permissions.Editors).trigger('change');

        Metronic.unblockUI();
    });
}

function setDocumentPermissions(documentID, viewers, editors) {
    Metronic.blockUI();

    var data = {
        documentID: documentID,
        viewers: viewers,
        editors: editors
    }

    callActionOnServer('SetDocumentPermissions', JSON.stringify(data), function (response) {
        error = response.d;

        if (error) {
            alert(error) 
        } else {
            bootbox.alert('Permissions set successfully');
        }

        Metronic.unblockUI();
    });
}


function setCategoryPermissions(categoryID, viewers, editors) {
    Metronic.blockUI();

    var overridePermissions = $('#override-permissions-checkbox').prop('checked');

    var data = {
        categoryID: categoryID,
        viewers: viewers,
        editors: editors,
        overridePermissions: overridePermissions
    }

    callActionOnServer('SetCategoryPermissions', JSON.stringify(data), function (response) {
        error = response.d;

        if (error) {
            alert(error)
        } else {
            bootbox.alert('Permissions set successfully');
        }

        Metronic.unblockUI();
    });
}

function isArchived(node) {
    try {
        return node.original.a_attr.class == "archived";
    } catch (e) {
        return false;
    }
}
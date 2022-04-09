
$(document).ready(function () {


    document.getElementById('topCat0').className = 'list-group-item active';
    document.getElementById('cat1').className = 'active';

    $('#myWizard').wizard();

    $('#myWizard').on('actionclicked.fu.wizard', function (e, data) {
    //console.log('step ' + data.step + ' requested');
        
        if (data.step==1)
        {
            if (document.getElementById('txtTitle').value == '')
            {
                alert('Title is mandatory');
                e.preventDefault();    
            }
        
        }

    });

    $('#myWizard').on('finished.fu.wizard', function (e, data) {
        saveItem();
    });

    loadKaizenItems('');
    
});

var aspxPage = 'kaizen.aspx';
var showingThreadId = 0;


function calcScore()
{
    var score = 0;
    var title = document.getElementById('txtTitle').value;
    var description = document.getElementById('txtDescription').value;
    var why1 = document.getElementById('txtWhy1').value;
    var why2 = document.getElementById('txtWhy2').value;
    var why3 = document.getElementById('txtWhy3').value;
    var why4 = document.getElementById('txtWhy4').value;
    var why5 = document.getElementById('txtWhy5').value;
    var what1 = document.getElementById('txtWhat').value;
    var what2 = document.getElementById('txtWhat2').value;
    var how = document.getElementById('txtHow').value;

    score = score + scoreDefault;
    if (title!='') score = score + scoreTitle;
    if (description!='') score = score + scoreDescription;
    if (why1!='') score = score + scoreWhys;
    if (why2!='') score = score + scoreWhys;
    if (why3!='') score = score + scoreWhys;
    if (why4!='') score = score + scoreWhys;
    if (why5!='') score = score + scoreWhys;
    if (what1!='') score = score + scoreQ1;
    if (what2!='') score = score + scoreQ2;
    if (how!='') score = score + scoreQ3;

    document.getElementById('labScore').innerHTML = score.toString();
}

function openModal()
{
    modalAsQuestion();
    calcScore();
    $('#category-modal').modal('show');
}

function doPoints(_id, _addRemove)
{
    var result = callActionOnServer('addRemovePoints','{ _id: ' + _id.toString() + ', _addRemove: ' + _addRemove + ' }', true, true);
    if (result.errors.length>0)
    {
        alert(result.errors[0]);
    }
    document.getElementById('labPoints' + _id).innerHTML = result.resultValue + 'pts';
}

function doView(_id)
{
    showingThreadId = _id;
    var result = callActionOnServer('getCompleteItem','{ _id: ' + _id.toString() + ' }', true, true);
    document.getElementById('divView' + _id.toString()).style.display = 'none';
    document.getElementById('divHide' + _id.toString()).style.display = 'inline';
    $('#ItemsList' + _id.toString()).html($('#item-body').tmpl(result));

}

function doHide(_id)
{
    $('#ItemsList' + _id.toString()).html('');
    document.getElementById('divView' + _id.toString()).style.display = 'inline';
    document.getElementById('divHide' + _id.toString()).style.display = 'none';

}

function clearModal()
{
    document.getElementById('txtTitle').value = '';
    document.getElementById('txtDescription').value = '';
    

    var _secondCat = secondCat;
    var _topCat = topCat;

    if (_secondCat == 0) _secondCat = 1;
    if (_topCat == 0) _topCat = 1;

    document.getElementById('cmbCategory1').selectedIndex = _secondCat - 1;
    document.getElementById('cmbCategory2').selectedIndex = _topCat - 1;
}

function modalAsAnswer(_id)
{
    clearModal();
    document.getElementById('groupCategory1').style.display = 'none';
    document.getElementById('groupCategory2').style.display = 'none';
    document.getElementById('groupTitle').style.display = 'none';
    document.getElementById('groupWhy1').style.display = 'none';
    document.getElementById('groupWhy2').style.display = 'none';
    document.getElementById('groupWhy3').style.display = 'none';
    document.getElementById('groupWhy4').style.display = 'none';
    document.getElementById('groupWhy5').style.display = 'none';
    document.getElementById('groupWhat').style.display = 'none';
    document.getElementById('groupWhat2').style.display = 'none';
    document.getElementById('groupHow').style.display = 'none';


    document.getElementById('txtParentId').value = _id.toString();
    document.getElementById('modalNewItemTitle').innerHTML = 'Add comment';

    $('#myWizard').wizard('selectedItem', { step: 3 });

}

function modalAsQuestion()
{
    clearModal();
    document.getElementById('FileUpload1').value = '';
    document.getElementById('txtParentId').value = '0';
    document.getElementById('groupCategory1').style.display = 'inline';
    document.getElementById('groupCategory2').style.display = 'inline';

    document.getElementById('groupTitle').style.display = 'inline';
    document.getElementById('groupWhy1').style.display = 'inline';
    document.getElementById('groupWhy2').style.display = 'inline';
    document.getElementById('groupWhy3').style.display = 'inline';
    document.getElementById('groupWhy4').style.display = 'inline';
    document.getElementById('groupWhy5').style.display = 'inline';

    document.getElementById('groupWhat').style.display = 'inline';
    document.getElementById('groupWhat2').style.display = 'inline';
    document.getElementById('groupHow').style.display = 'inline';

    document.getElementById('modalNewItemTitle').innerHTML = 'New Kaizen Item';
    $('#myWizard').wizard('selectedItem', { step: 1 });


}

function doAddComment(_id)
{
//    modalAsAnswer(_id);
    document.getElementById('txtAnswer').value = '';
    document.getElementById('txtParentId').value = _id.toString();
    $('#answer-modal').modal('show');

}

function saveItem()
{
    $("#category-modal").modal('hide');
    processLoading();
    setTimeout(saveReal,500);

}

function saveReal()
{
    var category1 = document.getElementById('cmbCategory1').value;
    var category2 = document.getElementById('cmbCategory2').value;
    var title = document.getElementById('txtTitle').value;
    var description = document.getElementById('txtDescription').value;
    var parentId = document.getElementById('txtParentId').value;

    var why1 = document.getElementById('txtWhy1').value;
    var why2 = document.getElementById('txtWhy2').value;
    var why3 = document.getElementById('txtWhy3').value;
    var why4 = document.getElementById('txtWhy4').value;
    var why5 = document.getElementById('txtWhy5').value;
    var what1 = document.getElementById('txtWhat').value;
    var what2 = document.getElementById('txtWhat2').value;
    var how = document.getElementById('txtHow').value;


//    input = document.getElementById('FileUpload1');          
//    if (input.value!="")
//    {
  //      var file1 = document.getElementById('FileUpload1').files[0];
    
    //    var arr = input.value.split('\\');
      //  var filename = arr[arr.length-1];
        // var reader = new FileReader();

          //    reader.onload = function (e) {
            //      base64 = e.target.result;
              //    callActionOnServer('createKaizenItem','{ _parentId: ' + parentId + ', _category1: ' + category1.toString() +', _category2: ' + category2.toString() +', _title: "' + title + '", _description: "' + description + '", _why1: "' + why1 + '", _why2: "' + why2 + '", _why3: "' + why3 + '", _why4: "' + why4 + '", _why5: "' + why5 + '", _what1: "' + what1 + '", _what2: "' + what2 + '", _how: "' + how + '", file1: "' + reader.result + '", _filename: "' + filename + '" }', false, false);

//              };


  //      reader.readAsDataURL(input.files[0]);
    //}
//    else
  //  {
    document.getElementById('butSubmit').click();
      //  callActionOnServer('createKaizenItem','{ _parentId: ' + parentId + ', _category1: ' + category1.toString() +', _category2: ' + category2.toString() +', _title: "' + title + '", _description: "' + description + '", _why1: "' + why1 + '", _why2: "' + why2 + '", _why3: "' + why3 + '", _why4: "' + why4 + '", _why5: "' + why5 + '", _what1: "' + what1 + '", _what2: "' + what2 + '", _how: "' + how + '", file1: "", _filename: "" }', false, false);    
    //}
    //alert('coco');
//        callActionOnServer2('createKaizenItem', data, true, false);
//            callActionOnServer2('test1', data, true, false);


    if (showingThreadId == 0)
    {
        loadKaizenItems('');
    }
    else
    {
        doView(showingThreadId);
    }

}

function saveAnswer()
{
    var category1 = document.getElementById('cmbCategory1').value;
    var category2 = document.getElementById('cmbCategory2').value;
    var description = document.getElementById('txtAnswer').value;
    var parentId = document.getElementById('txtParentId').value;

    $("#answer-modal").modal('hide');

    callActionOnServer('createKaizenItem','{ _parentId: ' + parentId + ', _category1: ' + category1.toString() +', _category2: ' + category2.toString() +', _title: "", _description: "' + description + '", _why1: "", _why2: "", _why3: "", _why4: "", _why5: "", _what1: "", _what2: "", _how: "", file1: "", _filename: "" }', true, false);

    if (showingThreadId!=0)
        doView(showingThreadId);
    else
        doView(parentId);
}

function loadKaizenItems(filter)
{
    showingThreadId = 0;

    var loadingModal = false;

    //alert(navigator.userAgent);
    //alert(navigator.userAgent.indexOf('Firefox'));
    if (navigator.userAgent.indexOf('Firefox')>-1 || navigator.userAgent.indexOf('Chrome')>-1)
    {
        //alert(navigator.userAgent);
        loadingModal = true;
    }

    var result = callActionOnServer('getKaizenItems','{ category1: ' + secondCat.toString() + ', category2: ' + topCat.toString() + ', search: "' + filter + '" }', loadingModal, loadingModal);
    //alert(result.length);
    //alert(result[0].username);

    //$.tmpl($('#section-content'), result).appendTo('#ItemsList');
    $('#ItemsList').html($('#section-content').tmpl(result));
}

//function createItem()
//{
//    alert(topCat);
//    alert(secondCat);
//    callActionOnServer('createKaizenItem','{ _category1: 1, _category2: 1, _title: "New kaizen item", _description: "this is a new kaizen item" }');
//    loadKaizenItems('');
//}


function callActionOnServer(action, params, showLoading, hideLoading)
{
        var res;
        if (showLoading) processLoading();

        $.ajax({
            type: "POST", url: aspxPage + "/" + action, data: params, contentType: "application/json; charset=utf-8", dataType: "json",
            success: function (result) {
                res = result.d;
            },
            failure: function (response) {
                alert(response.d);
            },
            async: false
        });

        if (hideLoading) endProcessLoading();
        return res;
}

function processLoading()
{
    //$("#loading-modal").modal('show');
    $("#loading-modal").modal('show');

}


function endProcessLoading()
{
    //$("#loading-modal").modal('hide');
    $("#loading-modal").modal('hide');
//    setTimeout(endProcessLoadingReal,10000);
}


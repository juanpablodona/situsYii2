<?php

use app\models\Bonification;
use yii\helpers\Html;
use yii\helpers\Url;
use yii\web\View;
use yii\widgets\ActiveForm;

/* @var $this View */
/* @var $model Bonification */
/* @var $form ActiveForm */
?>

<div class="bonification-form">
    <table>
        <?php
        $form = ActiveForm::begin([
                    'id' => 'bonification-form',
                    'enableAjaxValidation' => true,
                    'enableClientScript' => true,
                    'enableClientValidation' => true,]);
        ?>
        <?php  foreach ($model as $i => $mod): ?>

            <tr>
                <td>
                    <?=$form->field($mod, "[$i]year")->textInput(['value' => ($i + 1), 'readonly' => TRUE])?>
                        
                </td>
                <td>
                    <?=$form->field($mod, "[$i]amount")->textInput(['id'=>'b'.$i, 'onchange' => 'bonificatedMount('.$i.')'])?>  
                </td> 
                <td> 
                     <?=$form->field($mod, "[$i]contract_id")->hiddenInput(['value'=> $contract_id])->label('')?> 
                </td>
                <td>Cuota año 1: <span id="c<?=$i?>"></span></td>
            </tr>
        
        <?php endforeach; ?>
            <tr><td colspan="2">            
        <div class="form-group">
            <?= Html::submitButton('Siguiente', [ 'class'=> 'btn btn-success']) ?>
        </div>
                </td></tr>
        <?php ActiveForm::end(); ?>
    </table>
    
    
</div>

<script>
        
        var Bonifications= new function(){
            this.mount=<?=$contract_mount?>;
            this. init= function (){
                $(document).on("beforeSubmit", "form#bonification-form", function(e){
                    beforeSubmit(e);
                });
                $(document).on("submit", "form#bonification-form", function(e){
                    submit(e);
                });
            }
            
            
            function beforeSubmit(e){
                
                $.ajax({
                    url: '<?= Url::to(['bonification/create']) ?>' + '&submit=true',
                    data: $('form#bonification-form').serializeArray(),
                    method: 'POST',
                    success: function (result) {
                        if (result === '1') {
                            $.ajax({
                                url: '<?= Url::to(['person-contract/create']) ?>',
                                method: 'POST',
                                success: function (data) {
                                    $('.modal-body').html(data);
                                    $('#modal').modal();
                                }
                            });
                        }

                    },
                    dataType: 'json'
                    
                });

                return false;
                
                
            }
            
            function submit(e) {
                e.preventDefault();
                e.stopImmediatePropagation();
                return false;
            }
            
            
            
            
            
        }
        function bonificatedMount(i){
                $('#c'+ i).html(parseFloat(Bonifications.mount) - parseFloat($('#b'+ i).val()));
        }
</script>
<?= $this->registerJs('Bonifications.init()')?>
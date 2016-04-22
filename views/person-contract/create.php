<?php

use yii\helpers\Html;


/* @var $this yii\web\View */
/* @var $model app\models\PersonContract */

$this->title = 'Nuevo Contrato- Seleccion de Participantes';
$this->params['breadcrumbs'][] = ['label' => 'Person Contracts', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="person-contract-create">

    <h1><?= Html::encode($this->title) ?></h1>

    <?=
    GridView::widget([
        'id'=> 'personContract-grid',
        'dataProvider' => $persons,
        'columns' => [
            ['class' => 'yii\grid\SerialColumn'],
            'name',
            'first_surname',
            'document_number',
            [
                'class' => 'yii\grid\ActionColumn',
                'buttons' => [
                    'Locatario' => function ($url, $model, $key) {
                        return Html::a('Agregar Como Locatario', '#', [
                                    'id' => 'locator',
                                    'data-toggle' => 'modal',
                                    'data-target' => '#modal',
                                    'data-name' => $model->first_surname . ', '. $model->name,
                                    'data-dni' => $model->document_number
                                    
                        ]);
                    },
                    'Propietario' => function ($url, $model, $key) {
                        return Html::a('Agregar Como Propietario', '#', [
                                    'id' => 'owner',
                                    'data-toggle' => 'modal',
                                    'data-target' => '#modal',
                                    'data-name' => $model->first_surname . ', '. $model->name,
                                    'data-dni' => $model->document_number
                                    
                        ]);
                    },
                    'Garante' => function ($url, $model, $key) {
                        return Html::a('Agregar Como Garante', '#', [
                                    'id' => 'guarantor',
                                    'data-toggle' => 'modal',
                                    'data-target' => '#modal',
                                    'data-name' => $model->first_surname . ', '. $model->name,
                                    'data-dni' => $model->document_number
                        ]);
                    },
                    'Destinatarios' => function ($url, $model, $key) {
                        return Html::a('Agregar Como Destinatario', '#', [
                                    'id' => 'receiver',
                                    'data-toggle' => 'modal',
                                    'data-target' => '#modal',
                                    'data-name' => $model->first_surname . ', '. $model->name,
                                    'data-dni' => $model->document_number
                        ]);
                    },
                     ],
                    ]
                ],
            ]);
    ?>
    
    <h3>Personas Seleccionadas</h3>
    <table class="table" id="personSelected">
        <thead>
        <th>Nombre y Apellido</th>
        <th>Documento Numero</th>
        <th>Rol</th>
        </thead>
        <tbody>
            
        </tbody>
    </table>
    
    <a href="" id="finishButton" class="btn btn-success">Finalizar</a>
</div>

<script>
    
    var PersonContractFunctions= new function(){
        var PersonContractFunctions.persons=[];
        this.init= function(){
           $(document).on('click', '#locator', createLocator());
           $(document).on('click', '#owner', createOwner());
           $(document).on('click', '#guarantor', createGuarantor());
           $(document).on('click', '#receiver', createReceiver());
        }
        
        function createLocator(e){
            PersonContractFunctions.persons.push(
               {
                   person_id:$(this).data('personId'),
                   contract_id: $(this).data('contractId'), 
                   role: 'locator'
               }
            );
            $('#personSelected tbody').append('<tr><td>' + $(this).data('name') 
                    + '</td><td>' + $(this).data('dni') + '</td><td> Locatario</td></tr>' );
        }
        
        function createOwner(e){
            PersonContractFunctions.persons.push(
               {
                   person_id:$(this).data('personId'),
                   contract_id: $(this).data('contractId'), 
                   role: 'owner'
               }
            );
            $('#personSelected tbody').append('<tr><td>' + $(this).data('name') 
                    + '</td><td>' + $(this).data('dni') + '</td><td> Locador</td></tr>' );
        }
        
        function createGuarantor(e){
            PersonContractFunctions.persons.push(
               {
                   person_id:$(this).data('personId'),
                   contract_id: $(this).data('contractId'), 
                   role: 'guarantor'
               }
            );
            $('#personSelected tbody').append('<tr><td>' + $(this).data('name') 
                    + '</td><td>' + $(this).data('dni') + '</td><td>Garante</td></tr>' );
        }
        
        function createReceiver(e){
            PersonContractFunctions.persons.push(
               {
                   person_id:$(this).data('personId'),
                   contract_id: $(this).data('contractId'), 
                   role: 'receiver'
               }
            );
            $('#personSelected tbody').append('<tr><td>' + $(this).data('name') 
                    + '</td><td>' + $(this).data('dni') + '</td><td>Destinatario</td></tr>' );
        }
        
        function submitPersonsContract(){
            
            $.ajax({
                    url: '<?= Url::to(['person-contract/create'])?>' + '&contract_id='+'<?=$contract_id?>',
                    data: {datos: JSON.stringify(PersonContractFunctions.persons)},
                    method: 'POST',
                    success: function (result) {
                        if (result.status === '1') {
                            $.ajax({
                                url: '<?= Url::to(['bonification/create']) ?>' + '&duration=' + ContractFunctions.duration + '&contract_id=' + result.contract_id,
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
        
        
    }
    
    



</script>
<?= $this->registerJs('PersonContractFucntions.init()') ?>

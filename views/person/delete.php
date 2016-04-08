<?php

use yii\helpers\Html;
use yii\helpers\Url;
use yii\web\View;


/* @var $this yii\web\View */
/* @var $model app\models\Person */

$this->title = 'Eliminar Persona';
$this->params['breadcrumbs'][] = ['label' => 'People', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="person-delete">

    <h1><?= Html::encode($this->title) ?></h1>

    <p> Esta a punto de eliminar a  <?=$model->name . ' ' . $model->first_surname ?>. ¿Esta seguro de realizar
        esta accion?</p>
    
    <?php 
        echo yii\bootstrap\Html::a('Aceptar', '#', [
            'id' => 'aceptButton',
            'class' => 'btn btn-success',
            'data-url' => Url::to(['delete']). '&id='.$model->person_id.'&ok=TRUE',
            'data-pjax' => '0',]);
    
    ?>

</div>



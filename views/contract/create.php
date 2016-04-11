<?php

use yii\helpers\Html;


/* @var $this yii\web\View */
/* @var $model app\models\Contract */

$this->title = 'Nuevo Contrato';
$this->params['breadcrumbs'][] = ['label' => 'Contracts', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="contract-create">

    <h1><?= Html::encode($this->title) ?></h1>

    <?= $this->render('_form', [
        'model' => $model,
        'properties'=> $properties
    ]) ?>

</div>

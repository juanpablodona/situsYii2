<?php

use yii\helpers\Html;


/* @var $this yii\web\View */
/* @var $model app\models\Charge */

$this->title = 'Nuevo Cobro';
$this->params['breadcrumbs'][] = ['label' => 'Charges', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="charge-create">

    <h1><?= Html::encode($this->title) ?></h1>

    <?= $this->render('_form', [
        'model' => $model,
        'contract'=> $contract,
        
    ]) ?>

</div>

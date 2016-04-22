<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model app\models\Bonification */

$this->title = 'Nuevo Contrato - Bonificaciones';
$this->params['breadcrumbs'][] = ['label' => 'Bonifications', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>
<div class="bonification-create">

    <h1><?= Html::encode($this->title) ?></h1>
    <?=
        $this->render('_form', ['model' => $model, 'duration' => $duration, 'contract_id'=> $contract_id, 'contract_mount'=> $contract_mount]);
       
    ?>
        

</div>

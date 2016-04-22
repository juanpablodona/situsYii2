<?php

use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model app\models\Bonification */

$this->title = 'Update Bonification: ' . $model->bonification_id;
$this->params['breadcrumbs'][] = ['label' => 'Bonifications', 'url' => ['index']];
$this->params['breadcrumbs'][] = ['label' => $model->bonification_id, 'url' => ['view', 'id' => $model->bonification_id]];
$this->params['breadcrumbs'][] = 'Update';
?>
<div class="bonification-update">

    <h1><?= Html::encode($this->title) ?></h1>

    <?= $this->render('_form', [
        'model' => $model,
    ]) ?>

</div>

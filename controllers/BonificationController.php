<?php

namespace app\controllers;

use Yii;
use app\models\Bonification;
use yii\data\ActiveDataProvider;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;

/**
 * BonificationController implements the CRUD actions for Bonification model.
 */
class BonificationController extends Controller {

    /**
     * @inheritdoc
     */
    public function behaviors() {
        return [
            'verbs' => [
                'class' => VerbFilter::className(),
                'actions' => [
                    'delete' => ['POST'],
                ],
            ],
        ];
    }

    /**
     * Lists all Bonification models.
     * @return mixed
     */
    public function actionIndex() {
        $dataProvider = new ActiveDataProvider([
            'query' => Bonification::find(),
        ]);

        return $this->render('index', [
                    'dataProvider' => $dataProvider,
        ]);
    }

    /**
     * Displays a single Bonification model.
     * @param integer $id
     * @return mixed
     */
    public function actionView($id) {
        return $this->render('view', [
                    'model' => $this->findModel($id),
        ]);
    }

    /**
     * Creates a new Bonification model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return mixed
     */
    public function actionCreate($submit = FALSE, $duration = 0, $contract_id = 0) {
        $models = array();
        if (!$submit) {
            for ($index = 0; $index < ($duration - 1); $index++) {
                array_push($models, new Bonification());
            }
        }else{
            foreach (json_decode(Yii::$app->request->getParams()['Bonification']) as $b){
                $bonification= new Bonification;
                $bonification->year=$b->year;
                $bonification->amount= $b->amount;
                $bonification->contract_id= $b->contract_id;
                array_push($models, $bonification);
            }
        }

        if ($submit) {
            foreach ($models as $model) {
                if ($model->save()) {
                    $model->refresh();
                } else {
                    return 0;
                }
            }

            return 1;
        }

        $contract_mount = \app\models\Contract::findOne($contract_id)->amount;

        return $this->renderAjax('create', ['model' => $models, 'duration' => $duration, 'contract_id' => $contract_id, 'contract_mount' => $contract_mount]);
    }

    /**
     * Updates an existing Bonification model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param integer $id
     * @return mixed
     */
    public function actionUpdate($id) {
        $model = $this->findModel($id);

        if ($model->load(Yii::$app->request->post()) && $model->save()) {
            return $this->redirect(['view', 'id' => $model->bonification_id]);
        } else {
            return $this->render('update', [
                        'model' => $model,
            ]);
        }
    }

    /**
     * Deletes an existing Bonification model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     * @param integer $id
     * @return mixed
     */
    public function actionDelete($id) {
        $this->findModel($id)->delete();

        return $this->redirect(['index']);
    }

    /**
     * Finds the Bonification model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param integer $id
     * @return Bonification the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id) {
        if (($model = Bonification::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }

}

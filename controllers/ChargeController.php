<?php

namespace app\controllers;

use app\models\Charge;
use Yii;
use yii\data\ActiveDataProvider;
use yii\filters\VerbFilter;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\web\Response;
use yii\widgets\ActiveForm;

/**
 * ChargeController implements the CRUD actions for Charge model.
 */
class ChargeController extends Controller
{
    /**
     * @inheritdoc
     */
    public function behaviors()
    {
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
     * Lists all Charge models.
     * @return mixed
     */
    public function actionIndex()
    {
        $dataProvider = new ActiveDataProvider([
            'query' => Charge::find(),
        ]);

        return $this->render('index', [
            'dataProvider' => $dataProvider,
        ]);
    }

    /**
     * Displays a single Charge model.
     * @param integer $id
     * @return mixed
     */
    public function actionView($id)
    {
        return $this->renderAjax('view', [
            'model' => $this->findModel($id),
        ]);
    }

    /**
     * Creates a new Charge model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return mixed
     */
    public function actionCreate($contract_id, $submit= FALSE)
    {
        $model = new Charge();

        if (Yii::$app->request->isAjax && $model->load(Yii::$app->request->post()) && $submit== FALSE) {
            Yii::$app->response->format==Response::FORMAT_JSON;
            return json_encode(ActiveForm::validate($model));
        }
        
        if ($model->load(Yii::$app->request->post())) {
            if($model->save()){
                $model->refresh();
                return TRUE;
            } else {
                Yii::$app->response->format==Response::FORMAT_JSON;
                return json_encode(ActiveForm::validate($model));
            }
        }
        
        $contract= \app\models\Contract::findOne(['contract_id'=>$contract_id]);
        
        
        
        
        return $this->renderAjax('create', ['model' => $model, 'contract' => $contract]);
    }

    /**
     * Updates an existing Charge model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param integer $id
     * @return mixed
     */
    public function actionUpdate($id, $submit=FALSE)
    {
        $model = $this->findModel($id);

        if (Yii::$app->request->isAjax && $model->load(Yii::$app->request->post()) && $submit== FALSE) {
            Yii::$app->response->format==Response::FORMAT_JSON;
            return json_encode(ActiveForm::validate($model));
        }
        
        if ($model->load(Yii::$app->request->post())) {
            if($model->save()){
                $model->refresh();
                return TRUE;
            } else {
                Yii::$app->response->format==Response::FORMAT_JSON;
                return json_encode(ActiveForm::validate($model));
            }
        }
        
        $contract= $model->contract;
        
        return $this->renderAjax('update', ['model' => $model, 'contract'=> $contract]);
    }

    /**
     * Deletes an existing Charge model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     * @param integer $id
     * @return mixed
     */
    public function actionDelete($id, $ok= FALSE)
    {
        $model=$this->findModel($id);
        
        if ($ok) {
            $model->delete();
            return TRUE;
        }else{
            return $this->renderAjax('delete', ['model'=> $model]);
        } 
        
    }

    /**
     * Finds the Charge model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param integer $id
     * @return Charge the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id)
    {
        if (($model = Charge::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }
}

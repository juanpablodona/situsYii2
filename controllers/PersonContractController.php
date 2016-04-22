<?php

namespace app\controllers;

use Yii;
use app\models\PersonContract;
use yii\data\ActiveDataProvider;
use yii\web\Controller;
use yii\web\NotFoundHttpException;
use yii\filters\VerbFilter;

/**
 * PersonContractController implements the CRUD actions for PersonContract model.
 */
class PersonContractController extends Controller
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
     * Lists all PersonContract models.
     * @return mixed
     */
    public function actionIndex()
    {
        $dataProvider = new ActiveDataProvider([
            'query' => PersonContract::find(),
        ]);

        return $this->render('index', [
            'dataProvider' => $dataProvider,
        ]);
    }

    /**
     * Displays a single PersonContract model.
     * @param integer $id
     * @return mixed
     */
    public function actionView($id)
    {
        return $this->render('view', [
            'model' => $this->findModel($id),
        ]);
    }

    /**
     * Creates a new PersonContract model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     * @return mixed
     */
    public function actionCreate($contract_id, $datos= NULL)
    {
              
           
        if (Yii::$app->request->isAjax && $datos !== NULL) {
            foreach ($datos as $person) {
                $personContr= new PersonContract();
                $personContr->person_id= $person->person_id;
                $personContr->contract_id= $contract_id;
                $personContr->role= $person->role;
                if (!$personContr->save()) {
                   return json_encode(['status'=> 'fail', 'message'=> ' No se puede definir rol']); 
                }
            }
            
            return json_encode(['status'=> 'ok', 'message'=> ' Contrato creado con exito']); 
        }
        
        $persons= new ActiveDataProvider(['models' => \app\models\Person::find()->asArray()]);
        return $this->renderAjax('create', ['contract_id'=> $contract_id, 'persons'=>$persons]);
    }

    /**
     * Updates an existing PersonContract model.
     * If update is successful, the browser will be redirected to the 'view' page.
     * @param integer $id
     * @return mixed
     */
    public function actionUpdate($id)
    {
        $model = $this->findModel($id);

        if ($model->load(Yii::$app->request->post()) && $model->save()) {
            return $this->redirect(['view', 'id' => $model->person_contract_id]);
        } else {
            return $this->render('update', [
                'model' => $model,
            ]);
        }
    }

    /**
     * Deletes an existing PersonContract model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     * @param integer $id
     * @return mixed
     */
    public function actionDelete($id)
    {
        $this->findModel($id)->delete();

        return $this->redirect(['index']);
    }

    /**
     * Finds the PersonContract model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param integer $id
     * @return PersonContract the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id)
    {
        if (($model = PersonContract::findOne($id)) !== null) {
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }
}

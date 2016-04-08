<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "bonification".
 *
 * @property integer $bonification_id
 * @property double $amount
 * @property integer $year
 * @property integer $contract_id
 *
 * @property Contract $contract
 */
class Bonification extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'bonification';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['amount'], 'number'],
            [['year', 'contract_id'], 'required'],
            [['year', 'contract_id'], 'integer'],
            [['contract_id'], 'exist', 'skipOnError' => true, 'targetClass' => Contract::className(), 'targetAttribute' => ['contract_id' => 'contract_id']],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'bonification_id' => 'Bonification ID',
            'amount' => 'Amount',
            'year' => 'Year',
            'contract_id' => 'Contract ID',
        ];
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getContract()
    {
        return $this->hasOne(Contract::className(), ['contract_id' => 'contract_id']);
    }
}

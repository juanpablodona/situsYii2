<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "payment".
 *
 * @property integer $payment_id
 * @property integer $contract_id
 * @property string $payment_date
 * @property double $payment_mount
 * @property string $payment_period
 * @property string $comment
 * @property double $deductions
 * @property double $recharge
 * @property integer $charge_id
 * @property string $payment_words
 *
 * @property Charge $charge
 * @property Contract $contract
 */
class Payment extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'payment';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['contract_id', 'charge_id'], 'required'],
            [['contract_id', 'charge_id'], 'integer'],
            [['payment_date'], 'safe'],
            [['payment_mount', 'deductions', 'recharge'], 'number'],
            [['payment_period', 'payment_words'], 'string', 'max' => 45],
            [['comment'], 'string', 'max' => 255],
            [['charge_id'], 'exist', 'skipOnError' => true, 'targetClass' => Charge::className(), 'targetAttribute' => ['charge_id' => 'charge_id']],
            [['contract_id'], 'exist', 'skipOnError' => true, 'targetClass' => Contract::className(), 'targetAttribute' => ['contract_id' => 'contract_id']],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'payment_id' => 'Payment ID',
            'contract_id' => 'Contract ID',
            'payment_date' => 'Payment Date',
            'payment_mount' => 'Payment Mount',
            'payment_period' => 'Payment Period',
            'comment' => 'Comment',
            'deductions' => 'Deductions',
            'recharge' => 'Recharge',
            'charge_id' => 'Charge ID',
            'payment_words' => 'Payment Words',
        ];
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getCharge()
    {
        return $this->hasOne(Charge::className(), ['charge_id' => 'charge_id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getContract()
    {
        return $this->hasOne(Contract::className(), ['contract_id' => 'contract_id']);
    }
}

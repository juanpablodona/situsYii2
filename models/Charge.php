<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "charge".
 *
 * @property integer $charge_id
 * @property integer $contract_id
 * @property string $charge_date
 * @property double $charge_mount
 * @property string $charged_period
 * @property integer $municipality
 * @property integer $water_service
 * @property integer $expenses
 * @property string $comment
 * @property string $expiration
 * @property double $recharge
 * @property double $deductions
 * @property double $other_recharge
 * @property string $charge_words
 *
 * @property Contract $contract
 * @property Payment[] $payments
 */
class Charge extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'charge';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['contract_id'], 'required'],
            [['contract_id', 'municipality', 'water_service', 'expenses'], 'integer'],
            [['charge_date', 'expiration'], 'safe'],
            [['charge_mount', 'recharge', 'deductions', 'other_recharge'], 'number'],
            [['charged_period', 'charge_words'], 'string', 'max' => 45],
            [['comment'], 'string', 'max' => 255],
            [['contract_id'], 'exist', 'skipOnError' => true, 'targetClass' => Contract::className(), 'targetAttribute' => ['contract_id' => 'contract_id']],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'charge_id' => 'Charge ID',
            'contract_id' => 'Contract ID',
            'charge_date' => 'Charge Date',
            'charge_mount' => 'Charge Mount',
            'charged_period' => 'Charged Period',
            'municipality' => 'Municipality',
            'water_service' => 'Water Service',
            'expenses' => 'Expenses',
            'comment' => 'Comment',
            'expiration' => 'Expiration',
            'recharge' => 'Recharge',
            'deductions' => 'Deductions',
            'other_recharge' => 'Other Recharge',
            'charge_words' => 'Charge Words',
        ];
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getContract()
    {
        return $this->hasOne(Contract::className(), ['contract_id' => 'contract_id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getPayments()
    {
        return $this->hasMany(Payment::className(), ['charge_id' => 'charge_id']);
    }
}
